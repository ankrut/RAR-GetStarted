function result = iff(condition,trueResult,falseResult)
if condition
	if(lib.bool.isfunc(trueResult))
		result = trueResult();
	else
		result = trueResult;
	end
else
	if(lib.bool.isfunc(falseResult))
		result = falseResult();
	else
		result = falseResult;
	end
end