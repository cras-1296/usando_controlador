require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'Some example specs' do
    let(:car) do
      Car.create(make: 'Toyota', model: 'Yaris', year: 2019,
                 kilometers: 1000, max_wheel_usage_before_change: 12000,
                 max_trunk_space: 100)
    end
    context 'basic methods' do
      it 'should return basic model info' do
        expect(car.make).to eq 'Toyota'
        expect(car.model).to eq 'Yaris'
      end
    end
  end

  describe 'Specs for our custom methods' do
    let(:car) do
      Car.create(make: 'Toyota', model: 'Yaris', year: 2019,
                 kilometers: 1000, max_wheel_usage_before_change: 12000,
                 max_trunk_space: 100)
    end

    context '#full_model' do
      it 'returns the make + model + year in a string' do
        expect(car.full_model).to eq 'Toyota Yaris 2019'
      end

      it 'returns new info when model is updated' do
        car.update!(make: 'Kia')
        expect(car.full_model).to eq 'Kia Yaris 2019'
      end
    end

    context '#available_trunk_space' do
      it 'By default returns max_trunk_space (because default #current_trunk_usage is 0)' do
        expect(car.available_trunk_space).to eq car.max_trunk_space
      end

      it 'Available trunk space decreases with trunk usage' do
        car.update!(current_trunk_usage: 20)
        expect(car.available_trunk_space).to eq 80
      end
    end

    context '#kilometers_before_wheel_change' do
      it 'returns max by default' do
        expect(car.kilometers_before_wheel_change).to eq car.max_wheel_usage_before_change
      end

      it 'subtracts wheel usage from max to determine available' do
        car.update!(current_wheel_usage: 3000)
        expect(car.kilometers_before_wheel_change).to eq 9000
      end
    end

    context '#store_in_trunk' do
      it 'adds amount to trunk usage' do
        expect(car.current_trunk_usage).to eq 0
        car.store_in_trunk 25
        expect(car.current_trunk_usage).to eq 25
      end
    end

    context '#wheel_usage_status' do
      it 'says wheels are OK when usage is under the threshold' do
        expect(car.wheel_usage_status).to eq 'Wheels are OK, you can keep using them'
      end

      it 'asks you to change your wheels when usage is over warning threshold' do
        car.update!(current_wheel_usage: 11999)
        expect(car.wheel_usage_status).to eq 'Wheels are OK, you can keep using them'
      end
    end
  end
end
