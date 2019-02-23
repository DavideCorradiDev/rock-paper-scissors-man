-- Copyright (c) 2016 Davide Corradi - All Rights Reserved



--- This module allows the definition of classes to enable OOP in lua.
--- It supports multiple inheritance and type checking.
--- To define a static method, do not pass the self parameter, so that it will always act on the class prototype and not on the instance.
--- To define a static field, declare it is as local and only access it through static methods, so that all instances will share the same value.
--- It is not possible to define private members. Prefix their names with an underscore (_) to document that they should not be accessed directly.
--- To define a class constructor, define a method called new. This will be called when an object is instantiated with object = Class(params).
--- Also, the constructor will not be copied in derived classes, it has to be redefined (but the derived class may of course call the constructor of its parents).
--- It is possible to define a cpy() function to perform a deep copy of the object (remember that you only have references to objects, therefore if you just write a = b you will only copy the reference!).
--- It is possible to use other names to do same of course, but a field called cpy will not be copied in derived classes, forcing a redefinition of the deep copy operator.
--- @module class



-- Includes
local utils = require 'hzi.utils'
local errors = require 'hzi.errors'
local assert = assert
local setmetatable = setmetatable
local ipairs = ipairs
local pairs = pairs
local error = error
local _G = _G



-- Package instantiation.
local P = {}
if setfenv then setfenv(1, P) else _ENV = P end



--- declares a new class.
--- @tparam string typename the name of the type, used for type checks and conversion to string.
--- @tparam[opt] tab ... the base classes of the current class. Note that if a field with the same key is present in more than one parent class the declaration will fail.
--- @treturn tab a table reference containing the basic class definition. To avoid confusion it is good practice to assign the class to a reference with the same name as typeName.
function declare(typename, ...)

	-- Function arguments check
	-- Class typename
	assert(_G.type(typename) == 'string', 'Argument 1 must be of type string.')
	-- The base classes are passed by argument
	local bases = {...}
	for i, base in ipairs(bases) do
		assert(_G.type(base) == 'table', 'Arguments 2... must be of type table')
	end

	-- cls is the class table
	local cls = {}
	
	-- Copy base class contents into the new class to enable inheritance.
	for i, base in ipairs(bases) do
		for k, v in pairs(base) do
			-- If the field has already been defined, raise an error.
			if cls[k] ~= nil then error(type(cls[k]) .. ' ' .. k .. ' already defined in class ' ..  base:type() ..
				', impossible to declare ' .. type(v) .. ' ' .. k .. '.') end
			-- Copy all fields except:
			-- new: the constructor, should be redefined if needed.
			-- clone, copy, equals: used to make a deep copy and check object equality, a basic implementation will be provided and can be redefined if needed.
			-- __index: it will be correctly assigned later.
			-- is_a: it will be correctly assigned later.
			-- type: it will be correctly assigned later.
			-- typeOf: it will be correctly assigned later.
			if k ~= 'new' and
				k ~= 'copy' and
				k ~= 'clone' and
				k ~= 'equals' and
				k ~= '__index' and 
				k ~= 'is_a' and 
				k ~= 'type' and 
				k ~= 'typeOf' then
				-- utils.copy(cls[k], v)
				cls[k] = v
			end
		end
	end

	-- Set the class is_a field to enable type checks consistent with the inheritance.
	cls.is_a = {[cls] = true}
	for i, base in ipairs(bases) do
		for c in pairs(base.is_a) do
			cls.is_a[c] = true
		end
	end

	-- Set __index methamethod to fallback to the class, so that instances will use its methods.
	cls.__index = cls

	-- Set the type method to return the class type.
	function cls.type()
		return typename
	end	

	-- Set the typeOf method to enable type checks.
	function cls:typeOf(typename)
		if _G.type(typename) == 'table' then
			return self.is_a[typename]
		elseif _G.type(typename) == 'string' then
			for k, _ in pairs(self.is_a) do
				if k.type() == typename then
					return true
				end
			end
			return false
		else 
			error('Argument 1 must be of type string or table.')
		end
	end

	-- Set the copy and clone methods, used to deep copy an instance.
	function cls:clone()
		return utils.clone(self)
	end

	function cls:copy(other)
		assert(self:type() == other:type(), 'Invalid copy. Argument 1 is of type \'' .. self:type() .. '\', argument 2 is of type \'' .. other:type() .. '\'.')
		utils.copy(self, other)
	end

	function cls:equals(other)
		return utils.equals(self, other)
	end

	-- Set the __call methamethod to be able to use the instance = Class(...) syntax.
	setmetatable(cls, {
			__call = function(c, ...)
				local instance = setmetatable({}, c)
				-- If a constructor has been defined through the 'new' keyword, call it with the appropriate parameters.
				if instance.new then instance:new(...) end
				return instance
			end
		}
	)

	return cls

end



--- a table reference containing a class prototype.
--- @type Class

--- a set containing the type of the class and all of its base classes.
--- @table is_a

--- Should remove it, keep it for temporary reference.
--- @field Class.pippo

--- instantiates a new object. If the class contains a method called new, it will be called to initialize the new instance.
--- @function __call
--- @param tab c a reference to the table itself.
--- @param ... the parameters to be passed to the 'new' method when constructing the object.
--- @treturn tab the reference to an instance of the class.
--- @usage instance = Class(param1, param2)

--- returns the name of type of the class / instance as a string.
--- @function type
--- @treturn string the name of the type of the class / instance.

--- returns true if the class is of type typename, false otherwise.
--- @function typeOf
--- @tparam string typename a string containing the name of the type of the class.
--- @treturn bool true if the class / instance is of the specified type, false otherwise.

--- returns true if the class is of type typename, false otherwise.
--- @function typeOf
--- @tparam tab type a table reference to the Class type.
--- @treturn bool true if the class / instance is of the specified type, false otherwise.



function type(a)
	if _G.type(a) == 'table' and 
		_G.type(a.type) == 'function' then
		return a:type()
	else
		return _G.type(a)
	end
end



function equals(a, b)
	if _G.type(a) == 'table' and
		_G.type(a.equals) == 'function' then
		return a:equals(b)
	else
		return utils.equals(a, b)
	end
end



function clone(a)
	if _G.type(a) == 'table' and
		_G.type(a.clone) == 'function' then
		return a:clone()
	else
		return utils.clone(a)
	end
end



function copy(a, b)
	if _G.type(a) == 'table' and
		_G.type(a.copy) == 'function' then
		a:copy(b)
	else
		utils.copy(a, b)
	end
end



function typeOf(var, typeName)

	assert(_G.type(typeName) == 'string', errors.badType(2, 'typeOf', 'string', _G.type(typeName)))

	if _G.type(var) == 'table' then
		if type(var.typeOf) == 'function' then
			return var:typeOf(typeName)
		else
			return  _G.type(var) == typeName
		end
	else
		return _G.type(var) == typeName
	end

end


return P