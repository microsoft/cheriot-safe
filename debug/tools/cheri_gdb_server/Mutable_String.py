class Mutable_String:

    def __init__(self, string):
        self.string = list(string)

    def __str__(self):
        return ''.join(self.string)

    def __getitem__(self, index):
        return self.string[index]

    def __setitem__(self, index, value):
        self.string[index] = value

    def insert(self, index, value):
        self.string.insert(index, value)

    def append(self, value):
        self.string.append(value)

    def delete(self, index):
        del self.string[index]

    def concatenate(self, other):
        if isinstance(other, Mutable_String):
            self.string.extend(other.string)
        else:
            raise TypeError("Unsupported type. Only MutableString objects can be concatenated.")
    def reverse_string(self):
        return self.string[::-1]