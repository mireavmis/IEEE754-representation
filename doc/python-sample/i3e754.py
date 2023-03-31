from bitstring import*

def check_zero(a):
    flag = True
    for i in range(len(a)-1):
        flag &= str(a[i]) == '0'
    return flag


# binary 16
def main(_a):
    assert(len(_a) == 16)

    a = BitArray(bin='0b' + str(_a))

    ans = BitArray(bin='0b' + "0"*16)

    # if number is 0
    if check_zero(a.bin):
        ans = BitArray(bin='0b' + a.bin[-1] + "0" * 15)
        return ans.bin


    if a.bin[-1] == '1':
        a.reverse()

        a.invert()
        a = BitArray(uint=a.uint+1, length=16)
        a[0] = BitArray(bin='0b1')

        print(a.bin)
        a.reverse()

    # find last's '1' id
    i = 0
    for _ in range(len(a.bin) - 1):
        if a.bin[_] == '1':
            i = _

    print(i)
    # truncate
    if (i > 10):
        return "Error"

    ans[-1] = a[-1]
    ans[10:-1] = BitArray(reversed(BitArray(uint=i+15, length=5)))
    ans[0:10] = BitArray(bin='0b' + "0" * (10 - i) + a.bin[0:i])
    ans.reverse()

    return ans.bin
