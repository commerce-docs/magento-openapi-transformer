const Generator = require("../TagGroupsGenerator");

test('Test tag generation', ()=>{
    const pathsObject = {
        "/V1/customers": {
            "post": {
                "tags": ["customer"]
            }
        },
        "/V1/customers/login": {
            "post": {
                "tags": ["customerLogin"]
            },
            "get": {
                "tags": ["customerLogin"]
            }
        },
        "/V1/shopping-cart": {
            "post": {
                "tags": ["shoppingCart"]
            }
        },
        "/V1/shopping-cart/{cartId}": {
            "post": {
                "tags": ["shoppingCartId"]
            }
        }
    };

    const expected = [
        {
            "name": "customers",
            "tags": ["customer","customerLogin"]
        },
        {
            "name": "shopping cart",
            "tags": ["shoppingCart", "shoppingCartId"]
        }
    ];

    const result = Generator.generate(pathsObject);

    expect(result).toEqual(expected); 
});
