//Copyright (c) 2010 Nicholas C. Zakas. All rights reserved.
//MIT License

var EventTarget = function (){
    this._listeners = {};
}

EventTarget.prototype = {
	
    constructor: EventTarget,

    addListener: function(type, listener){
        if (typeof this._listeners[type] === "undefined"){
            this._listeners[type] = [];
        }

        this._listeners[type].push(listener);
    },

    fire: function(type, data){
    	if (typeof data === 'undefined' || typeof data !== 'object') {
    		event = {};
    	}
    	else {
    		event = data;
    	}
        event.type = type;
        if (!event.target){
            event.target = this;
        }
        if (!event.type){  //falsy
            throw new Error("Event object missing 'type' property.");
        }

        if (this._listeners[event.type] instanceof Array){
            var listeners = this._listeners[event.type];
            for (var i=0, len=listeners.length; i < len; i++){
                listeners[i].call(this, event);
            }
        }
    },

    removeListener: function(type, listener){
        if (this._listeners[type] instanceof Array){
            var listeners = this._listeners[type];
            for (var i=0, len=listeners.length; i < len; i++){
                if (listeners[i] === listener){
                    listeners.splice(i, 1);
                    break;
                }
            }
        }
    }
};

