@listar
Feature: Listar productos usando la API /api/v1/product/
	Background:
    * url 'http://localhost:8081'
    * def ruta_crear = '/api/v1/product/'
		* def result = callonce read('nuevo.feature')
		* print result.response
      
	Scenario: Actualizar un producto de forma exitosa
    Given path ruta_crear,"/",result.response.sku,"/"
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match responseType == 'json'
    And match $ == {"products":'#array',"status":true,"message":"El producto fue encontrado"} 
    And match response.products[0].sku ==  result.response.sku
    
  Scenario: Buscar un producto de forma no exitosa por sku no existente
    #sku no existente
    * def sku = '6ab5af78-daea-4d48-aede-04f945084a9b'
    Given path ruta_crear, sku
    And header Accept = 'application/json'
    When method get
    Then status 404
    And match response.status == 404
    And match response.error == 'Not Found'
    
 Scenario: Buscar un producto de forma no exitosa por name no existente
    #producto no exite
    * def producto = 'Iphone 15 minito'
    Given path ruta_crear,
    And param name = producto
    And header Accept = 'application/json'
    When method get
    Then status 404
    And match response.status == 404
    And match response.error == 'Not Found'