import i3e754
import pytest

# reverse input that LSB - 0

@pytest.mark.parametrize("a, res", [("0000000110111010", "0"+"10111"+"1011101000"),
                                    ("1111110101101100", "1"+"11000"+"0100101000")])
def test_good(a, res):
    assert i3e754.main(a[::-1]) == res


@pytest.mark.parametrize("a, res", [("0001111101000101", "Error"),
                                    ("1" + "0" * 15, "Error")])
def test_error(a, res):
    assert i3e754.main(a[::-1]) == res


@pytest.mark.parametrize("a, res", [("0" * 16, "0" * 16)])
def test_zero(a, res):
    assert i3e754.main(a[::-1]) == res
