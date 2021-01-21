#include <iostream>
#include <folly/init/Init.h>
#include <folly/io/async/EventBase.h>
#include <folly/fibers/Baton.h>
#include <folly/fibers/FiberManagerMap.h>

int main(int argc, char **argv) {
	folly::init(&argc, &argv);
	folly::EventBase evb;
	auto& fiberManager = folly::fibers::getFiberManager(evb);
	folly::fibers::Baton baton;
	fiberManager.addTask([&]{
		std::cout << "Task 1: start" << std::endl;
		baton.wait();
		std::cout << "Task 1: after baton.wait()" << std::endl;
	});


	fiberManager.addTask([&]{
		std::cout << "Task 2: start" << std::endl;
		baton.post();
		std::cout << "Task 2: after baton.post()" << std::endl;
	});


	evb.loop();
	return 0;
}
