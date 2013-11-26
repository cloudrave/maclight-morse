#!/usr/bin/ruby

require 'maclight'

BASE_TIME_UNIT = 0.12
DIT = 1 * BASE_TIME_UNIT
DAH = 3 * BASE_TIME_UNIT
INTER_GAP = 1 * BASE_TIME_UNIT
SHORT_GAP = 3 * BASE_TIME_UNIT
MEDIUM_GAP = 7 * BASE_TIME_UNIT

MORSE_DICTIONARY = {
    'A' => '.-',
    'B' => '-...',
    'C' => '-.-.',
    'D' => '-..',
    'E' => '.',
    'F' => '..-.',
    'G' => '--.',
    'H' => '....',
    'I' => '..',
    'J' => '.---',
    'K' => '-.-',
    'L' => '.-..',
    'M' => '--',
    'N' => '-.',
    'O' => '---',
    'P' => '.--.',
    'Q' => '--.-',
    'R' => '.-.',
    'S' => '...',
    'T' => '-',
    'U' => '..-',
    'V' => '...-',
    'W' => '.--',
    'X' => '-..-',
    'Y' => '-.--',
    'Z' => '--..',
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
    def display; raise "Abstract method"; end
end

class Dit < MorseFragment
    def display
        @light.setState(1)
        sleep DIT
        @light.setState(0)
    end
end

class Dah < MorseFragment
    def display
        @light.setState(1)
        sleep DAH
        @light.setState(0)
    end
end


# light = KeyboardLight.new
# dit = Dit.new(light)
# dah = Dah.new(light)

string = ARGV[0].to_s.upcase

words = string.split(' ')
words.each do |word|
    letters = word.split('')
    letters.each do |letter|
        encodedBits = MORSE_DICTIONARY[letter]
        encodedBits.split('').each do |encodedBit|
            case encodedBit
            when '.'
                MacLight.capslock(true)
                print "·"
                STDOUT.flush
                sleep DIT
                MacLight.capslock(false)
            when '-'
                MacLight.capslock(true)
                print "–"
                STDOUT.flush
                sleep DAH
                MacLight.capslock(false)
            else
                raise "Unexpected encoded bit"
            end
            sleep INTER_GAP
        end
        sleep SHORT_GAP
    end
    sleep MEDIUM_GAP
end



