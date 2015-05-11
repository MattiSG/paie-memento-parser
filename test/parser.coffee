parser = require '../parser'

SOURCE = __dirname + '/../item.html';

describe 'Parser', ->
	actual = parser.parse SOURCE

	it 'should parse one item', ->
		actual.should.have.length 1

	describe 'parsed item', ->
		before ->
			actual = actual[0]

		it 'should have a name', ->
			actual.name.should.equal '3 . Taux unique sur tranches B et C (n° 5382).'

		it 'should have an id', ->
			actual.id.should.equal '25005'

		it 'should have a period', ->
			actual.period.should.equal 'month:2015-01'

		it 'should be clean of underscore-prefixed items', ->
			actual.should.not.have.property '_separationColumn'

		describe 'payroll', ->
			it 'should start with the first row', ->
				actual.data[0].name.should.equal 'Salaire mensuel'

			it 'should start with the first amount', ->
				actual.data[0].positiveAmount.should.equal '12 900,00'

		it 'should have a description', ->
			actual.description.should.equal
"Cadre dirigeant dont la rémunération est déterminée sans
référence à sa durée de travail. L'entreprise cotise au même
taux sur la tranche B et la tranche C :
16,44 %, appelé à 125 %, soit 20,55 %.
Les cotisations sur tranche B sont réparties à 7,80 % pour le
salarié et 12,75 % pour l'employeur.
Les cotisations sur tranche C sont réparties à 8,39 % pour le
salarié et 12,16 % pour l'employeur.
La rémunération est trop élevée pour donner lieu à la réduction
générale de cotisations patronales.
Données communes : n° 25000."
