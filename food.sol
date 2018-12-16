pragma solidity ^0.4.18;

/****************************************SafeMath***************************************************************
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    /// assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    /// assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

 /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
/***********************************************SafeMath Ending ***************************************************/


/**************************************************Food *******************************************/
contract Food {

	using SafeMath for uint256;	//Using safemath

    address public F;		// Farmer shall be the owner, we shall be initializing this variable's value by the address of the
							// user who's going to deploy it. e.g. let's say F itself.

    uint256 public totalNoOfFood;	
    // Constructor whose code is run only when the contract is created.
    function Food() public {
        F = msg.sender; // setting the owner of the contract as Food F.
    }

    /// modifier to check the tx is coming from the DA(owner) or not.
    modifier onlyOwner() {
        require(msg.sender == F);
        _;
    }

    /// This structure is kept like this for storing a lot more information than just the name
    struct FoodDetails {
		                
        string name;	
        string origin;
        uint256 FoodCount;
        bool isSold;
    }				
    mapping(address => mapping(uint256=>FoodDetails)) public foodOwner; 
																		
    mapping(address => uint256) individualCountOfFoodPerOwner;		

    event FoodAlloted(address indexed _verifiedOwner, uint256 indexed  _totalNoOfFoodCurrently, string _nameOfFood, string _originOfFood, string _msg);

    //event FoodTransferred(address indexed _from, address indexed _to, string _foodName, string _msg);


    function getFoodCountOfAnyAddress(address _ownerAddress) public constant returns (uint256){
        uint count=0;
        for(uint i =0; i<individualCountOfFoodPerOwner[_ownerAddress];i++){
            if(foodOwner[_ownerAddress][i].isSold != true)
            count++;
        }
        return count/2;
    }

    /// this function shall be called by Farmer only after verification
    function allotProperty(address _verifiedOwner, string _foodName, string _origin) public onlyOwner {
        foodOwner[_verifiedOwner][individualCountOfFoodPerOwner[_verifiedOwner]++].name = _foodName;
        foodOwner[_verifiedOwner][individualCountOfFoodPerOwner[_verifiedOwner]++].origin = _origin;
        totalNoOfFood++;
        FoodAlloted(_verifiedOwner,individualCountOfFoodPerOwner[_verifiedOwner], _foodName, _origin, "food allotted successfully");
    }

    function isOwner(address _checkOwnerAddress, string _foodName) public constant returns (string){
        uint i ;
        bool flag ;
        for(i=0 ; i<individualCountOfFoodPerOwner[_checkOwnerAddress]; i++){
            if(foodOwner[_checkOwnerAddress][i].isSold == true){
                break;
            }
         flag = stringsEqual(foodOwner[_checkOwnerAddress][i].name,_foodName);
            if(flag == true){
                break;
            }
        }
        if(flag == true){
            return foodOwner[_checkOwnerAddress][1].origin;
        }
        else {
            return "NA";
        }
    }

    /// functionality to check the equality of two strings in Solidity
    function stringsEqual(string a1, string a2) private constant returns (bool) {
        if(sha3(a1) == sha3(a2))
            return true;
        else
            return false;
    }

    /// transfer the property to the new owner
    /// todo : change from to msg.sender

    /*function transferFood (address _to, string _foodName) public returns (bool ,  uint )
    {
        uint256 checkOwner = isOwner(msg.sender, _foodName);
        bool flag;

        if(checkOwner != 999999999 && foodOwner[msg.sender][checkOwner].isSold == false){
            /// step 1 . remove the property from the current owner and decrase the counter.
            /// step 2 . assign the property to the new owner and increase the counter
            foodOwner[msg.sender][checkOwner].isSold = true;
            foodOwner[msg.sender][checkOwner].name = "Sold";// really nice finding. we can't put empty string
            foodOwner[_to][individualCountOfFoodPerOwner[_to]++].name = _foodName;
           //foodOwner[_to][individualCountOfFoodPerOwner[_to]++].origin = _origin;
            flag = true;
            FoodTransferred(msg.sender , _to, _foodName, "Owner has been changed." );
        }
        else {
            flag = false;
            FoodTransferred(msg.sender , _to, _foodName, "Owner doesn't own the property." );
        }
        return (flag, checkOwner);
        
    }*/
}