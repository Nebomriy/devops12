import random

def guess_number():
    guess=random.randint(1, 100)
    # print (guess)
    print (" ")
    print ("У вас є 5 спроб вгадати число. Введіть число від 1 до 100. ")
    for i in range(5):
        try:
            user_input = int(input("Введіть ваше число: "))
        except ValueError:
            print("Помилка! Запустіть програму ще раз і введіть на цей раз дійсне ціле число.")
            return
        if user_input == guess:
            print("Вітаємо! Ви вгадали число!")
            return 
        elif user_input < guess:
            print("Ваше число менше загаданого.")
        else:
            print("Ваше число більше загаданого.")
    print(f"Ви не вгадали. Загадане число було: {guess}")

guess_number()