$ = Sizzle

models = {}

attrs =
	eprefix: 'b\\:'
	prefix: 'b\:'
	bind: 'bind'
	scope: 'scope'
	attrs: 'attrs'

class Observable extends EventTarget
	constructor: (properties) ->
		super()
		for property, value of properties
			@[property] = value
	
	get: (property) ->
		return this[property]
	
	set: (property, value) ->
		@[property] = value
		@fire 'change', {property: property, value: value}
		return this[property]


class Model extends Observable
	constructor: (properties) ->
		super(properties)

ascend = ( element, stopPredicate = (-> false ) ) ->
	if not stopPredicate(element) and element.parentNode?
		return ascend(element.parentNode, stopPredicate)
	return element

getScope = (startElement) ->
	matchElement = ascend startElement, ( eachElement ) ->
		return Sizzle.matchesSelector( eachElement, '['+attrs.eprefix+attrs.scope+']' )
	return matchElement

withScope = (element, callback) ->
	scopeElement = getScope( element )
	scopeAttr = attrs.prefix + attrs.scope
	if scopeElement.hasAttribute( scopeAttr )
		scope = scopeElement.getAttribute( scopeAttr )
		callback(scope)

doBindings = (context = window.document.documentElement) ->
	bindElements = $('['+attrs.eprefix+attrs.bind+']', context)
	
	for bindElement in bindElements
		do (bindElement) ->
			withScope bindElement, (scope) ->
				bindAttr = attrs.prefix + attrs.bind
				bindProp = bindElement.getAttribute( bindAttr )
				modelScope = models[scope]
				update = ->
					bindValue = modelScope.get( bindProp )
					bindElement.innerHTML = bindValue
				update()
				models[scope].addListener 'change', update
	
	attrsElements = $('['+attrs.eprefix+attrs.attrs+']', context)
	
	for attrsElement in attrsElements
		do (attrsElement) ->
			withScope attrsElement, (scope) ->
				attrsAttr = attrs.prefix + attrs.attrs
				attrsProp = attrsElement.getAttribute( attrsAttr )
				modelScope = models[scope]
				update = ->
					attrsObject = modelScope.get( attrsProp )
					for attrName, attrValue of attrsObject
						attrsElement.setAttribute( attrName, attrValue )
				update()
				models[scope].addListener 'change', update

window.bindmap =
	Model: Model
	go: (opts) ->
		models = opts.models
		onReady = ->
			doBindings()

		if document.readyState isnt 'complete'
			document.onready = onReady
		else
			onReady()

