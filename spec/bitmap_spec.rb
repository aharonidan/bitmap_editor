require './spec/spec_helper'

describe Bitmap do

    describe '#initialize' do

        it "should create new image" do
           image = Bitmap.new(3,4)
           expect(image.columns).to eq 3
           expect(image.rows).to eq 4
           expect(image.to_s).to eq "OOO\nOOO\nOOO\nOOO\n"
        end

        it "should raise error if dimensions are out of range" do
            expect { Bitmap.new(-1, 1) }.to raise_error(ArgumentError)
            expect { Bitmap.new(1, -1) }.to raise_error(ArgumentError)
            expect { Bitmap.new(Bitmap::SIZE_LIMIT + 1, 1) }.to raise_error(ArgumentError)
            expect { Bitmap.new(1, Bitmap::SIZE_LIMIT + 1) }.to raise_error(ArgumentError)
        end
    end

    describe '#colour_pixel' do
        it "should colour pixel" do
            image = Bitmap.new(3,4)
            image.colour_pixel(3, 3, 'X')
            expect(image.to_s).to eq "OOO\nOOO\nOOX\nOOO\n"
        end

        it "should raise error if index is out of bounds" do
            image = Bitmap.new(3,4)
            expect { image.colour_pixel(4 ,1 ,'X') }.to raise_error(ArgumentError)
        end
    end

    describe '#colour_vertical' do
        it "should colour vertical line" do
            image = Bitmap.new(3,4)
            image.colour_vertical(2, 2, 4, 'X')
            expect(image.to_s).to eq "OOO\nOXO\nOXO\nOXO\n"
        end
    end

    describe '#colour_horizontal' do
        it "should colour vertical line" do
            image = Bitmap.new(3,4)
            image.colour_horizontal(2, 3, 2, 'X')
            expect(image.to_s).to eq "OOO\nOXX\nOOO\nOOO\n"
        end
    end
end