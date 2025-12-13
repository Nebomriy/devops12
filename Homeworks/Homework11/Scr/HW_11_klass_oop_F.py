class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters  # список літер

    def print(self):
        print(" ".join(self.letters))

    def letters_num(self):
        return len(self.letters)


class EngAlphabet(Alphabet):
    __letters_num = 26  # приватний статичний атрибут

    def __init__(self):
        super().__init__("EN", list("ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

    def s_en_letter(self, letter):
        return letter.upper() in self.letters

    def letters_num(self):
        return EngAlphabet.__letters_num

    @staticmethod
    def example():
        return "London is the capital of Great Britain."


# ===== Тести =====
if __name__ == "__main__":
    alph = EngAlphabet()

    alph.print()
    print(f"Кількість літер: {alph.letters_num()}")

    print(f"Чи належить 'F' англійському алфавіту? {alph.s_en_letter('F')}")
    print(f"Чи належить 'Щ' англійському алфавіту? {alph.s_en_letter('Щ')}")

    print(EngAlphabet.example())
