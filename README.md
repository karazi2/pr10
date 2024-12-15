# АНТОНОВ ЯРОСЛАВ ЭФБО-02-22
# ПРАКТИКА 10

1. Создание БД в postgres
  Создание таблиц
 CREATE TABLE apartments (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    image_link TEXT,
    description TEXT,
    square_meters INT,
    bedrooms INT,
    price NUMERIC(10, 2) NOT NULL,
    favourite BOOLEAN DEFAULT FALSE
);

CREATE TABLE cart (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    apartment_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (apartment_id) REFERENCES apartments (id)
);

![image](https://github.com/user-attachments/assets/d0690bc3-07d6-41b6-b9f9-49fc2c485b63)

2. Настройка сервера с использованием Gin
  Был разработан backend-сервер на Go с использованием фреймворка Gin
  Созданы маршруты для работы с таблицами apartments (квартиры) и cart (корзина)


Запрос GET 
![image](https://github.com/user-attachments/assets/06806f16-bbcd-4d52-8253-48ab01f7fb3b)
![image](https://github.com/user-attachments/assets/6384b838-f32e-4a09-93a9-1476c9c55685)



Запрос GET 
![image](https://github.com/user-attachments/assets/ad3239d7-abe7-4b64-ac58-742df02da7bc)
![image](https://github.com/user-attachments/assets/81c45c08-069c-47ec-9ef6-fa49c8dcdaf7)


Запрос DELETE
![image](https://github.com/user-attachments/assets/3bc82b4b-da13-48f1-b75b-c6f50858c1c5)
![image](https://github.com/user-attachments/assets/4716a231-2de5-49da-89ca-3b3ea8188fff)


Запрос PUT 
![image](https://github.com/user-attachments/assets/faeccf86-8446-4b10-a908-754652f3e745)
![image](https://github.com/user-attachments/assets/6bfa40a1-efb6-45d0-b433-537f06335dac)


Запрос POST 
![image](https://github.com/user-attachments/assets/d92cf01b-018b-43ea-9798-7a9f3d9f84e5)
![image](https://github.com/user-attachments/assets/094120d1-6bf6-4d77-ba87-6f45ba5486a4)


Запрос PUT
![image](https://github.com/user-attachments/assets/2770da66-0086-4481-ad94-524d535b79b3)
![image](https://github.com/user-attachments/assets/72feef53-930e-4840-99da-33d793093d14)








