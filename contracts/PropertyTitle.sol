pragma solidity ^0.5.11;


contract PropertyTitle {

    address public registrar;
    uint propertyCount;

    constructor() public {
        registrar = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        propertyCount = 0;
    }   
    
    struct Property {
        uint id;
        uint value;
        string propAddress;
        address owner;
        bool sold;
    }
    
    mapping(address => Property[]) public __properties;

    //declaring an event 
    event Add(address ethaddress, uint _landID);
    /* 
    * Ans A. add new property for sale
    * 
    */
    function add(uint _value, string memory _addr, address _owner) public {
        propertyCount = propertyCount +1;
        Property memory  myProperty = Property({
            id : propertyCount,
            value : _value,
            propAddress: _addr,
            owner: _owner,
            sold: false
        });
        __properties[registrar].push(myProperty);
        // log output event
        emit Add(_owner, propertyCount);
    }
     
    /*
    * Ans B. Buy / Transfer ownership
    */
    function buy(uint _id, address _newOwner) public
    {
        for (uint i=0; i< __properties[registrar].length; i++)
        {
            // search for id
            if (__properties[registrar][i].id == _id)
            {
              // ensure buyer and seller not the same
              require(__properties[registrar][i].owner != _newOwner);
              // check property is on sale
              require(__properties[registrar][i].sold == false);
              // change property ownership and mark as sold
              __properties[registrar][i].owner = _newOwner;
              __properties[registrar][i].sold = true;
              break;
            }
        }         
    }

    /**
    * Ans C. Get all unsold LandID
    * @dev Return unsold LandID
    */
    function getUnsold() public view returns (uint [] memory)
    {
        uint [] memory ret = new uint[](__properties[registrar].length);
        uint unsoldCount =0;
        for (uint i=0; i< __properties[registrar].length; i++)
        {
            if (__properties[registrar][i].sold == false)
            {
              ret[unsoldCount] = __properties[registrar][i].id;
              unsoldCount++;
            }
        }
        
        return ret;
    }
    
    /*
    * Ans D. get property detail using ID and adrress
    * return property value and Address
    */
    function getProperty(uint _id, address _owner) public view returns (uint, string memory)
    {
        for (uint i=0; i< __properties[registrar].length; i++)
        {
            // search propId and owner address
            if (__properties[registrar][i].id == _id
                && __properties[registrar][i].owner == _owner)
            {
              return (__properties[registrar][i].value, __properties[registrar][i].propAddress) ;
            }
        }
        
        return (0, "Not Found");
    }
    
    /*
    * Ans E. Edit property detail
    * return updated value
    */
    function setProperty(uint _id, uint _value, address _owner) public returns (uint, address)
    {
        for (uint i=0; i< __properties[registrar].length; i++)
        {
            if (__properties[registrar][i].id == _id)
            {
              __properties[registrar][i].value = _value;
              __properties[registrar][i].owner = _owner;
              return (_value, _owner);
            }
        } 
        
        return (0, address(0));
    }
        

}