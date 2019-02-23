-- Copyright (c) 2016 Davide Corradi - All Rights Reserved


-- Package instantiation.
local P = {}
if setfenv then setfenv(1, P) else _ENV = P end



function badType(argumentPosition, functionName, expectedType, actualType)
	return 'bad argument # ' .. argumentPosition .. ' to \'' .. functionName .. '\' (' .. expectedType .. ' expected, got ' .. actualType .. ')'
end


function badPolymorphicType(argumentPosition, functionName, expectedType)
	return 'bad argument # ' .. argumentPosition .. ' to \'' .. functionName .. '\' (should be of type ' .. expectedType .. ' or derived)'

end

return P