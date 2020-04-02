require("utils/ClassesCache")
--------------------------------------------------------ResponsibilityChainFactory start----------------------------------------------------------
local AbsResponsibilityChainBuilder = {

}

local ResponsibilityChainFactory = {
    AbsResponsibilityChainBuilder = AbsResponsibilityChainBuilder,
}
_G.ResponsibilityChainFactory = ResponsibilityChainFactory

function AbsResponsibilityChainBuilder:onAsyncFailedResponseToNextNode()
	local clsNextNode = self.m_clsCurrentNode.m_clsNextNode;
	return clsNextNode and clsNextNode[self.m_szInterfaceName] 
		and clsNextNode[self.m_szInterfaceName](clsNextNode, unpack(self.m_tVariableParams));
end

function AbsResponsibilityChainBuilder:new(clsChain, szInterfaceName)
	self.m_clsChain = clsChain;
	clsChain.m_szInterfaceName = szInterfaceName or "intercept";
	clsChain.m_clsCurrentNode = nil;
	clsChain.m_clsHead = nil;
	clsChain.m_clsTail = nil;

	clsChain[szInterfaceName] = function(self, ...)
		self.m_clsCurrentNode = self.m_clsHead;
		self.m_tVariableParams = {...}
		return self.m_clsHead[self.m_szInterfaceName](self.m_clsHead, ...);
	end

	clsChain.onAsyncFailedResponseToNextNode = self.onAsyncFailedResponseToNextNode;
	return self;
end

function AbsResponsibilityChainBuilder:__addNode(clsInsertedNode, funcIntercept)
	local clsChain = self.m_clsChain;
	if not clsChain.m_clsHead then
		clsChain.m_clsHead = clsInsertedNode;
	elseif clsChain.m_clsTail then
		clsChain.m_clsTail.m_clsNextNode = clsInsertedNode;
	else
		local clsNode = clsChain.m_clsHead;
		while clsNode.m_clsNextNode do
			clsNode = clsNode.m_clsNextNode;
		end
		clsNode.m_clsNextNode = clsInsertedNode;
	end
	clsChain.m_clsTail = clsInsertedNode;
	clsInsertedNode.m_clsChain = self.m_clsChain;
	self:register(clsInsertedNode, funcIntercept);
	return self;
end

function AbsResponsibilityChainBuilder:register(clsNode, funcIntercept)
	clsNode[self.m_clsChain.m_szInterfaceName] = function(self, ...)
		local clsChain = self.m_clsChain;
		clsChain.m_clsCurrentNode = self;
		if funcIntercept(clsChain, ...) then
			return true
		end

		local clsNextNode = self.m_clsNextNode;
		return clsNextNode and clsNextNode[clsChain.m_szInterfaceName] 
		and clsNextNode[clsChain.m_szInterfaceName](clsNextNode, ...);
	end
end

function AbsResponsibilityChainBuilder:addNode(funcIntercept)
	self:__addNode({}, funcIntercept)
	return self;
end

function AbsResponsibilityChainBuilder:addDerivativeNode(funcIntercept, clsParent)
	clsParent.__index = clsParent;
	local clsDerivativeNode = {}
	setmetatable(clsDerivativeNode, clsParent);
	self:__addNode(clsDerivativeNode, funcIntercept)
	return self;
end

function ResponsibilityChainFactory:wrap(clsChain, szInterfaceName)
	local builder = ClassesCache:obtain("ResponsibilityChainBuilder");
    AbsResponsibilityChainBuilder.__index = AbsResponsibilityChainBuilder;
    ClassesCache:insertSuperClass(builder, AbsResponsibilityChainBuilder);
	return builder:new(clsChain, szInterfaceName);
end

function ResponsibilityChainFactory:create(szInterfaceName)
	return self:wrap({}, szInterfaceName);
end
--------------------------------------------------------ResponsibilityChainFactory end----------------------------------------------------------