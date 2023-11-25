@actualizar
Feature: Actualizar un producto usando la API /api/v1/product/

	Background:
		* url 'http://localhost:8081'
		* def ruta_crear = '/api/v1/product/'
		Given path ruta_crear,"/"
		And request { name: 'Iphone 99', description: 'Este es un smartphone de alta gama', price: 9999 }
		When method post
		Then status 201
		* def sku_creado = response.sku

	Scenario Outline: Actualizar un producto de forma exitosa
		Given path ruta_crear,"/",sku_creado,"/"
		And request <producto>
		And header Accept = 'application/json'
		When method put
		Then status 200
		And match responseType == 'json'
		And match $ == {"sku":'#notnull',"status":true,"message":"El producto fue actualizado con éxito"}
		Examples:
			| producto                                                                                       |
			| { name: 'Iphone Actualizado', description: 'Este es un smartphone de alta gama', price: 9999 } |
			| { name: 'Iphone 99', description: 'Descripcion Actualizada', price: 9999 }                     |
			| { name: 'Iphone 99', description: 'Este es un smartphone de alta gama', price: 90000 }         |


	Scenario Outline: Actualizar un producto de forma no exitosa
		Given path ruta_crear,"/",sku_creado,"/"
		And request <producto>
		And header Accept = 'application/json'
		When method put
		Then status 400
		And match responseType == 'json'
		And match $ == {"sku":'#notnull',"status":false,"message":"El producto no pudo ser actualizado"}
		Examples:
			| producto                                                                                       |
			| { name: 'Iphone Actualizado', description: 'Este es un smartphone de alta gama', price: 9999 } |
			| { name: 'Iphone 99', description: 1400, price: 9999 }                     |
			| { name: false, description: 'Este es un smartphone de alta gama', price: 90000 }         |


