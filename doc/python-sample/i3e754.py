from bitstring import*


# binary 16
def main(_a):
    assert(len(_a) == 16)

    a = BitArray(bin='0b' + str(_a) + '0')
    sign = a[15]

    ans = BitArray(bin='0b' + '0' * 16)

    # if number is 0
    if a.any(1) == False:
        return BitArray(bin='0b' + '0' * 16).bin

    # if number is negative
    if sign:
        a.reverse()
        a.invert()

        # make reg for carry be 0
        a[0] = 0

        a = BitArray(uint=a.uint+1, length=17)
        a.reverse()

    # truncate
    a.reverse()
    if a.uint > 2**11:
        return "Error"
    a.reverse()

    # find last's '1' id
    i = 0
    for _ in range(len(a.bin) - 1):
        if a.bin[_] == '1':
            i = _

    ans[-1] = sign
    ans[10:-1] = BitArray(reversed(BitArray(uint=i+15, length=5)))
    ans[0:10] = BitArray(bin='0b' + "0" * (10 - i) + a.bin[0:i])
    ans.reverse()

    return ans.bin
