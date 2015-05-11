parser = require '../src/parser'

SOURCE = __dirname + '/item.html';

describe 'Parser', ->
	actual = parser.parse SOURCE

	it 'should parse one item', ->
		actual.should.have.length 1

	describe 'parsed item', ->
		before ->
			actual = actual[0]

		it 'should have a name', ->
			actual.name.should.equal '3 . Taux unique sur tranches B et C (n° 5382).'

		it 'should have an id', ->
			actual.id.should.equal '25005'

		it 'should have a period', ->
			actual.period.should.equal 'month:2015-01'

		it 'should be clean of underscore-prefixed items', ->
			actual.should.not.have.property '_separationColumn'

		describe 'payroll', ->
			target = null

			before ->
				target = actual.data

			it 'should have the expected amount of rows', ->
				target.should.have.length 29

			describe 'base salary', ->
				before ->
					target = actual.data[0]

				it 'should have proper name', ->
					target.name.should.equal 'Salaire mensuel'

				it 'should have proper amount', ->
					target.positiveAmount.should.equal '12 900,00'

			describe 'tax', ->
				before ->
					target = actual.data[2]

				it 'should have proper name', ->
					target.name.should.equal 'Ass. maladie-solid. autonomie sur brut'

				it 'should have proper base', ->
					target.base.should.equal '12 900,00'

				it 'should have proper assiette', ->
					target.assiette.should.equal '0,75'

				it 'should have proper negativeAmount', ->
					target.negativeAmount.should.equal '96,75'

				it 'should have proper employerBase', ->
					target.employerBase.should.equal '13,10'

				it 'should have proper employerAmount', ->
					target.employerAmount.should.equal '1 689,90'

		it 'should have a description', ->
			actual.description.should.equal "Cadre dirigeant dont la rémunération est déterminée sans référence à sa durée de travail. L'entreprise cotise au même taux sur la tranche B et la tranche C : 16,44 %, appelé à 125 %, soit 20,55 %. Les cotisations sur tranche B sont réparties à 7,80 % pour le salarié et 12,75 % pour l'employeur. Les cotisations sur tranche C sont réparties à 8,39 % pour le salarié et 12,16 % pour l'employeur. La rémunération est trop élevée pour donner lieu à la réduction générale de cotisations patronales. Données communes : n° 25000."
