models =
	page: new bindmap.Model {
		name: 'World'
		attrs:
			style: 'color: red;'
			class: 'foo bar'
	}
	other: new bindmap.Model {
		name: 'Other'
	}

bindmap.go {
	models: models
}
