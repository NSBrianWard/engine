assert = chai.assert
expect = chai.expect

describe 'Domain', ->
	describe 'single solving domain', ->
		it 'should find solutions', ->
			window.engine = new GSS.Engine()
			expect(engine.solve [
				['==',
					['get', 'result']
					['+',
						['get', 'a']
						1
					]
				]
			]).to.eql 
				result: 0
				a: -1

	describe 'solving and assumed domains together', ->
		it 'should calculate simplified expression', ->
			window.engine = new GSS({
				a: 666
			})

			debugger
			expect(engine.solve [
				['==',
					['get', 'result']
					['+',
						['get', 'a']
						1
					]
				]
			]).to.eql 
				result: 667


		it 'should simplify partially', ->
			window.engine = new GSS({
				a: 555
			})

			expect(engine.solve [
				['=='
					['get', 'b'],
					10
				],
				['==',
					['get', 'result']
					['+',
						['*'
							2,
							['get', 'a']]
						['get', 'b']
					]
				]
			]).to.eql 
				result: 555 * 2 + 10
				b: 10

			expect(engine.solve
				a: -555
			).to.eql
				result: -1100