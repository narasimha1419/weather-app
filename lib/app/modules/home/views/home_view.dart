import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.determinePosition();
        },
        child: Obx(() => controller.isLoading.value
            ? Center(child: Text("Loading ........"))
            : GetBuilder<HomeController>(
                init: HomeController(),
                initState: (_) => HomeController().determinePosition(),
                builder: (_controller) => Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Pull to Refresh',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            _controller.localStoage
                                .read('weatherInfo')['location']['name'],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _controller.localStoage
                                    .read('weatherInfo')['current']['temp_c']
                                    .toString() +
                                ' c',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 80,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: _controller.localStoage
                                    .read('weatherInfo')['forecast']
                                        ['forecastday'][0]['hour']
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  var weatherDetailstoday = _controller
                                          .localStoage
                                          .read('weatherInfo')['forecast']
                                      ['forecastday'][0]['hour'][index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x28000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    margin:
                                        EdgeInsets.only(bottom: 5, right: 5),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(_controller.getTime(
                                            weatherDetailstoday['time'])),
                                        Spacer(),
                                        Text(
                                          "${weatherDetailstoday['temp_c']} c",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: _controller.localStoage
                                      .read('weatherInfo')['forecast']
                                          ['forecastday']
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var weatherDetails = _controller.localStoage
                                            .read('weatherInfo')['forecast']
                                        ['forecastday'][index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x28000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      margin: EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text(index == 0
                                                  ? 'Today'
                                                  : _controller.getDay(
                                                      weatherDetails['date'])),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(weatherDetails['date']),
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            "Min Temp : ${weatherDetails['day']['mintemp_c']} c",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Max Temp : ${weatherDetails['day']['maxtemp_c']} c",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    ))),
      ),
    );
  }
}
