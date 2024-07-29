CREATE TABLE "ingredients" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT,
    "price" INTEGER,
    "unit" TEXT
);

CREATE TABLE "donuts" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT,
    "gluten_free" INTEGER, -- Use INTEGER for boolean values in SQLite
    "price" INTEGER
);

CREATE TABLE "customers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "first_name" TEXT,
    "last_name" TEXT
);

CREATE TABLE "orders" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "order_number" INTEGER,
    "donut_id" INTEGER,
    "customer_id" INTEGER,
    FOREIGN KEY ("donut_id") REFERENCES donuts(id),
    FOREIGN KEY ("customer_id") REFERENCES customers(id)
);

CREATE TABLE "donuts_ingredients" (
    "donut_id" INTEGER,
    "ingredient_id" INTEGER,
    FOREIGN KEY ("donut_id") REFERENCES donuts(id),
    FOREIGN KEY ("ingredient_id") REFERENCES ingredients(id)
);

CREATE TABLE "orders_history" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "order_id" INTEGER,
    "customer_id" INTEGER,
    FOREIGN KEY ("order_id") REFERENCES orders(id),
    FOREIGN KEY ("customer_id") REFERENCES customers(id)
);
