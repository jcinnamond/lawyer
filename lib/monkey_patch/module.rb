class Module
  def implements(contract)
    contract.check!(self)
  end
end
