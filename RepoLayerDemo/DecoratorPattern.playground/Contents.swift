import UIKit

// MARK: - Component
protocol Vehicle {
	var weight: Double { get }
	var topSpeed: Double { get }
}

// MARK: - ConcreteComponent
struct Car: Vehicle {
	var weight: Double {
		return 2000
	}
	var topSpeed: Double {
		return 90
	}
}

// MARK: - AbstractDecorator
protocol VehicleDecorator: Vehicle {
	var vehicle: Vehicle { get }
}

// The reasonable default is to proxy the
// call to the inner vehicle object
extension VehicleDecorator {
	var weight: Double {
		return vehicle.weight
	}
	var topSpeed: Double {
		return vehicle.topSpeed
	}
}

// MARK: - ConcreteDecorator

// The bigger engine weighs 100 lbs more and
// will let us go 50 mph faster
struct EngineUpgrade: VehicleDecorator {
	let vehicle: Vehicle

	var weight: Double {
		return vehicle.weight + 100
	}

	var topSpeed: Double {
		return vehicle.topSpeed + 50
	}
}

// This upgrade does not affect the
// weight of the car
struct AirIntakeUpgrade: VehicleDecorator {
	let vehicle: Vehicle

	var topSpeed: Double {
		return vehicle.topSpeed * 1.1
	}
}


// MARK: - Decorating a Component
var car: Vehicle = Car()
car.topSpeed // 90
car.weight // 2000

car = EngineUpgrade(vehicle: car)
car.topSpeed // 140
car.weight // 2100

car = AirIntakeUpgrade(vehicle: car)
car.topSpeed // 154
car.weight // 2100
