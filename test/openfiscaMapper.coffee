mapper = require '../src/openfiscaMapper'


describe 'Mapper', ->
	describe 'OpenFisca object', ->
		NAME	= '3 . Taux unique sur tranches B et C (n° 5382).'
		ID		= '25005'
		PERIOD	= 'month:2015-01'
		SOURCE	=
			name	: NAME
			id		: ID
			period	: PERIOD
			data	: [
				{
					name: 'Salaire mensuel'
					positiveAmount: '12 900,00'
				}, {
					name: 'Ass. maladie-solid. autonomie sur brut'
					base: '12 900,00'
					employeeBase: '0,75'
					employeeAmount: '96,75'
					employerBase: '13,10'
					employerAmount: '1 689,90'
				}
			]

		actual = mapper.toOpenFisca SOURCE

		it 'should have a name', ->
			actual.name.should.equal NAME

		it 'should have an id', ->
			actual.id.should.equal ID

		it 'should have a period', ->
			actual.period.should.equal PERIOD

		it 'should have input variables', ->
			actual.input_variables.should.have.property 'salaire_de_base'
			actual.input_variables.salaire_de_base.should.equal 12900

		it 'should not have data', ->
			actual.should.not.have.property 'data'

		describe 'output variables', ->
			it 'should have employer amount', ->
				actual.output_variables.should.have.property 'mmid_employeur'
				actual.output_variables.mmid_employeur.should.equal -1689.90

			it 'should have employee amount', ->
				actual.output_variables.should.have.property 'mmid_salarie'
				actual.output_variables.mmid_salarie.should.equal -96.75


	describe 'parseNumber', ->
		it 'should parse integers', ->
			mapper.parseNumber('12 900,00').should.equal 12900

		it 'should negate numbers if requested', ->
			mapper.parseNumber('1 689,90', '-').should.equal -1689.90


	describe 'mapRow', ->
		target = null

		beforeEach ->
			target = { input_variables: {} }

		it 'should map an input variable to the matching OpenFisca input variable', ->
			mapper.mapRow.bind(target)({ name: 'Salaire mensuel' })
			target.input_variables.should.have.property 'salaire_de_base'

		it 'should map an input variable with end notes to the matching OpenFisca input variable', ->
			mapper.mapRow.bind(target)({ name: 'Salaire mensuel (1) (3) ' })
			target.input_variables.should.have.property 'salaire_de_base'

		it 'should sum elements with same targets', ->
			mapper.mapRow.bind(target)({ name: 'Salaire mensuel', positiveAmount: 1 })
			mapper.mapRow.bind(target)({ name: 'Salaire mensuel 35 h', positiveAmount: 2 })
			target.input_variables.salaire_de_base.should.equal 3
