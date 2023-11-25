@crear
Feature: Crear un nuevo producto usando la API /api/v1/product/

  Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
    * def nuevo_producto =
      """
      {
      "name": "Iphone 15",
      "description": "Este es un smartphone de alta gama",
      "price": 1500,
      }
      """

  Scenario: Crear un producto de forma exitosa
    * def producto =
      """
      {
      "name": "Iphone 14",
      "description": "Este es un smartphone de alta gama",
      "price": 1400,
      }
      """
    Given url 'http://localhost:8081/api/v1/product/'
    And request producto
    And header Accept = 'application/json'
    When method post
    Then status 201

  Scenario: Crear un producto de forma exitosa
    Given url 'http://localhost:8081/api/v1/product/'
    And request { name: 'Iphone 12', description: 'Este es un smartphone de alta gama', price: 1200 }
    And header Accept = 'application/json'
    When method post
    Then status 201

  Scenario: Crear un producto de forma exitosa, usando path y validando el response
    Given path "/api/v1/product/","/"
    And request nuevo_producto
    And header Accept = 'application/json'
    When method post
    Then status 201
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue creado con éxito!"}

  Scenario: Crear un producto de forma exitosa, path, response
    Given path ruta_crear,"/"
    And request nuevo_producto
    And header Accept = 'application/json'
    When method post
    Then status 201
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue creado con éxito!"}

  Scenario Outline: Crear un producto de forma exitosa, path, response usando examples
    Given path ruta_crear,"/"
    And request <producto>
    And header Accept = 'application/json'
    When method post
    Then status 201
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue creado con éxito!"}
    Examples:
      | producto                                                                 |
      | { name: 'Iphone 16', description: 'Telefono de alta gama', price: 1600 } |
      | { name: 'Iphone 17', description: 'Telefono de alta gama', price: 1700 } |
      | { name: 'Iphone 18', description: 'Telefono de alta gama', price: 1800 } |
      | { name: 'Iphone 19', description: 'Telefono de alta gama', price: 1900 } |


  Scenario Outline: Crear un producto de forma no exitosa, path
    Given path ruta_crear,"/"
    And request <producto>
    And header Accept = 'application/json'
    When method post
    Then status 404
    Examples:
      | producto                                           |
      | { name: 123, description: 13000, price: false }    |
      | { name: $#"#!", description: total, price: false } |
      | { name: false, description: 1450, price: true }    |

  Scenario Outline: Crear un producto de forma no exitosa, usando path y validando el response
    * def nuevo_producto2 =
      """
      {
      "name": "Iphone 15",
      "description": "Este es un smartphone de alta gama",
      "price": false,
      }
      """
    Given path ruta_crear,"/"
    And request nuevo_producto2
    And header Accept = 'application/json'
    When method post
    Then status 404
    And match responseType == 'json'
    And match $ == {"sku":'#notnull',"status":true,"message":"El producto no fue creado con éxito!"}
