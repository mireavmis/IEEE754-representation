import i3e754
import pytest

def hex_to_bin(a, reverse = 1):
    hex_to_binary = {
    '0': '0000',
    '1': '0001',
    '2': '0010',
    '3': '0011',
    '4': '0100',
    '5': '0101',
    '6': '0110',
    '7': '0111',
    '8': '1000',
    '9': '1001',
    'A': '1010',
    'B': '1011',
    'C': '1100',
    'D': '1101',
    'E': '1110',
    'F': '1111'
}
    ans = []
    for i in range(len(a)):
        ans.append(hex_to_binary[a[i]])

    if (reverse):
        print((''.join(ans))[::-1])
        return (''.join(ans))[::-1]
    else:
        return ''.join(ans)


# reverse input that LSB - 0


@pytest.mark.parametrize("a, res", [("01BA", "5EE8"),
                                    ("FD6C", "E128")])
def test_good(a, res):
    assert i3e754.main(hex_to_bin(a)) == hex_to_bin(res, 0)


@pytest.mark.parametrize("a, res", [("1F45", "Error"),
                                    ("8000", "Error")])
def test_error(a, res):
    assert i3e754.main(hex_to_bin(a)) == res


@pytest.mark.parametrize("a, res", [("0000", "0000")])
def test_zero(a, res):
    assert i3e754.main(hex_to_bin(a)) == hex_to_bin(res, 0)


