# Binary numbers in Two's complement
class Binary
  class InvalidBinaryFormat < StandardError
    attr_reader :binary_value, :expected_bits

    def initialize(binary_value, expected_bits)
      @binary_value = binary_value
      @expected_bits = expected_bits
    end

    def message
      "Given binary number `#{binary_value}` has #{binary_value.length} bits but was expected to have #{expected_bits} bits."
    end
  end

  attr_reader :binary_value,
    :bits

  # @param value [String] binary value in two's complement
  #   E.g "1000_1001" for -119
  # @param bits [Integer] number of expected bits,
  #   by default set to 8 bits
  def initialize(binary_value, bits = 8)
    @binary_value = binary_value.gsub("_", '')
    raise InvalidBinaryFormat.new(@binary_value, bits) if @binary_value.length != bits
    @bits = bits
  end

  # @return [Integer] decimal value of this binary number.
  def to_i
    b = binary_value.to_i(2)
    return (b - 2**bits) if b >= 2**(bits - 1)
    b
  end

  # @param index [Integer] bit of binary number.
  # @return [String] get the value of a given bit
  def [](index)
    binary_value[index]
  end

  # Perform AND operation on two binary numbers.
  # 
  # @param other [Binary] other binary number.
  # @return [Binary] result of AND operation between this
  #   binary number and another number
  def &(other)
    value = (0..bits-1).map do |index| 
      other[index].to_i(2) & self[index].to_i(2) 
    end.join
    Binary.new(value)
  end

  # Perform OR operation on two binary numbers.
  # 
  # @param other [Binary] other binary number.
  # @return [Binary] result of OR operation between this
  #   binary number and another number
  def |(other)
    value = (0..bits-1).map do |index| 
      other[index].to_i(2) | self[index].to_i(2) 
    end.join
    Binary.new(value)
  end

  # Perform XOR operation on two binary numbers.
  # 
  # @param other [Binary] other binary number.
  # @return [Binary] result of XOR operation between this
  #   binary number and another number
  def ^(other)
    value = (0..bits-1).map do |index| 
      other[index].to_i(2) ^ self[index].to_i(2) 
    end.join
    Binary.new(value)
  end

  # @return [Boolean] bitwise not version of this binary.
  #   ~Binary.new("0101_0101").binary_value 
  #   #=> "10101010"
  def ~@
    value = (0..bits-1).map do |index| 
      1 - self[index].to_i(2)
    end.join
    Binary.new(value)
  end

  # Right bit shift
  # 
  # 1000 >> 1 == 1100
  # 
  # @param bits [Integer] right shift by number of bits
  # @return [Binary] shifted version
  def >>(bits=1)
    most_left_bit = self[0]
    left_part = most_left_bit * bits
    right_part = self[0..(-1 - bits)]
    value = "#{left_part}#{right_part}"
    Binary.new(value)
  end

  # Left bit shift
  # 
  # 1111 << 1 == 1110 // -1 * 2 is -2
  # 1110 << 1 == 1100 // -2 * 2 is -4
  # 1101 << 1 == 1010 // -3 * 2 is -6
  # 1100 << 1 == 1000 // -4 * 2 is -8
  # 
  # @param bits [Integer] left shift by number of bits
  # @return [Binary] shifted version
  def <<(bits=1)
    value = self[bits..-1] + "0" * bits
    Binary.new(value)
  end
end
