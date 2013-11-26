#!/usr/bin/ruby

require 'maclight'

BASE_TIME_UNIT = 0.14
DIT = 1 * BASE_TIME_UNIT
DAH = 3 * BASE_TIME_UNIT
INTER_GAP = 1 * BASE_TIME_UNIT
SHORT_GAP = 3 * BASE_TIME_UNIT
MEDIUM_GAP = 7 * BASE_TIME_UNIT

MORSE_DICTIONARY = {
    'a' => '.-',
    'b' => '-...',
    'c' => '-.-.',
    'd' => '-..',
    'e' => '.',
    'f' => '..-.',
    'g' => '--.',
    'h' => '....',
    'i' => '..',
    'j' => '.---',
    'k' => '-.-',
    'l' => '.-..',
    'm' => '--',
    'n' => '-.',
    'o' => '---',
    'p' => '.--.',
    'q' => '--.-',
    'r' => '.-.',
    's' => '...',
    't' => '-',
    'u' => '..-',
    'v' => '...-',
    'w' => '.--',
    'x' => '-..-',
    'y' => '-.--',
    'z' => '--..',
    '1' => '.----',
    '2' => '..---',
    '3' => '...--',
    '4' => '....-',
    '5' => '.....',
    '6' => '-....',
    '7' => '--...',
    '8' => '---..',
    '9' => '----.',
    '0' => '-----',
}

class KeyboardLight
    @state = 0
    def setState(state)
        if state == 0
            bool = false
        elsif state == 1
            bool = true
        else
            raise "Undefined MacLight state"
        end
        MacLight.capslock(bool)
        @state = state
        puts @state
    end
end


class MorseFragment
    def initialize(light)
        @light = light
    end
    def display_bits
        @bits.each do |bit|
            bit.display
        end
    end
    def display; raise "Abstract method"; end
end

class Dit < MorseFragment
    def display
        @light.setState(1)
        sleep DIT
        @light.setState(0)
        sleep INTER_GAP
    end
end


class Dah < MorseFragment
    def display
        @light.setState(1)
        sleep DAH
        @light.setState(0)
        sleep INTER_GAP
    end
end


class InterGap < MorseFragment
    def display
        @light.setState(0)
        sleep SHORT_GAP
    end
end



class Letter < MorseFragment
    def initialize(light, letter)
        super(light)
        if letter.length > 1
            raise "Letter can only be one character long"
        end
        @bits ||= []
        encodedBits = MORSE_DICTIONARY[letter]
        encodedBits.split('').each do |encodedBit|
            case encodedBit
            when '.'
                bit = Dit.new(@light)
            when '-'
                bit = Dah.new(@light)
            else
                raise "Unexpected encoded bit"
            end
            @bits << bit
        end
        @bits << InterGap.new(@light)
    end
    def display
        display_bits()
        sleep SHORT_GAP
    end
end

class WordGap < MorseFragment
    def display
        @light.setState(0)
        sleep MEDIUM_GAP
    end
end

class Letter < MorseFragment
    def initialize(light, word)
        super(light)
        if word.index(' ') != nil
            raise "No spaces are allowed inside of a single word"
        end
        @bits ||= []
        letters = word.split('')
        letters.each do |letter|
            @bits << Letter.new(light, letter)
        end
    end
    def display

    end
end

light = KeyboardLight.new
# myDah = Dah.new(light)
b = Letter.new(light, 'b')
b.display()


