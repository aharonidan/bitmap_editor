require './spec/spec_helper'

describe BitmapEditor do

  let(:editor) { BitmapEditor.new }

  describe 'bitmap editor operations' do

    it 'should show help message' do
      expect { editor.send(:validate_and_run, '?') }.to output(/Help/).to_stdout
    end

    it 'should exit' do
      expect { editor.send(:validate_and_run, 'X') }.to output(/goodbye/).to_stdout
    end

    it 'should not recognise known input' do
      expect { editor.send(:validate_and_run, 'foo') }.to output(/unrecognised/).to_stdout
    end

    it 'should require image' do
      expect { editor.send(:validate_and_run, 'S') }.to output(/image required/).to_stdout
    end

    it 'should print image' do
      editor.send(:validate_and_run, 'I 2 2')
      expect { editor.send(:validate_and_run, 'S') }.to output("OO\nOO\n").to_stdout
    end

    it 'should colour pixel' do
      editor.send(:validate_and_run, 'I 2 2')
      editor.send(:validate_and_run, 'L 2 2 X')
      expect { editor.send(:validate_and_run, 'S') }.to output("OO\nOX\n").to_stdout
    end

    it 'should clear image' do
      editor.send(:validate_and_run, 'I 2 2')
      editor.send(:validate_and_run, 'L 2 2 X')
      editor.send(:validate_and_run, 'C')
      expect { editor.send(:validate_and_run, 'S') }.to output("OO\nOO\n").to_stdout
    end

    it 'should colour vertical line' do
      editor.send(:validate_and_run, 'I 3 3')
      editor.send(:validate_and_run, 'V 1 2 3 X')
      expect { editor.send(:validate_and_run, 'S') }.to output("OOO\nXOO\nXOO\n").to_stdout
    end

    it 'should colour horizontal line' do
      editor.send(:validate_and_run, 'I 3 3')
      editor.send(:validate_and_run, 'H 2 3 2 X')
      expect { editor.send(:validate_and_run, 'S') }.to output("OOO\nOXX\nOOO\n").to_stdout
    end

    it 'should not allow to exceed dimensions limit' do
      expect { editor.send(:validate_and_run, "I 1 #{Bitmap::SIZE_LIMIT + 1}") }.to output(/dimensions must be between/).to_stdout
    end

    it 'should not allow to colour out of range' do
      editor.send(:validate_and_run, 'I 2 2')
      expect { editor.send(:validate_and_run, 'L 3 3 A') }.to output(/index out of bounds/).to_stdout
    end

    it 'should do multiple operations' do
      editor.send(:validate_and_run, 'I 5 6')
      editor.send(:validate_and_run, 'L 2 3 A')
      expect { editor.send(:validate_and_run, 'S') }.to output("OOOOO\nOOOOO\nOAOOO\nOOOOO\nOOOOO\nOOOOO\n").to_stdout
      editor.send(:validate_and_run, 'V 2 3 6 W')
      editor.send(:validate_and_run, 'H 3 5 2 Z')
      expect { editor.send(:validate_and_run, 'S') }.to output("OOOOO\nOOZZZ\nOWOOO\nOWOOO\nOWOOO\nOWOOO\n").to_stdout
    end
  end
end