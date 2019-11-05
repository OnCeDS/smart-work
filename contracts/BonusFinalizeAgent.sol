pragma solidity ^0.4.6 >= 0.6.0 ;

import "./Crowdsale.sol";
import "./CrowdsaleToken.sol";
import "./SafeMathLib.sol";


contract BonusFinalizeAgent is FinalizeAgent {

  using SafeMathLib for uint256;

  CrowdsaleToken public token;
  Crowdsale public crowdsale;

   uint public bonusBasePoints;

  address public teamMultisig;

  uint public allocatedBonus;

  function BonusFinalizeAgent(CrowdsaleToken _token, Crowdsale _crowdsale, uint _bonusBasePoints, address _teamMultisig) {
    token = _token;
    crowdsale = _crowdsale;
    if(address(crowdsale) == 0) {
      throw;
    }

    teamMultisig = _teamMultisig;
    if(address(teamMultisig) == 0) {
      throw;
    }

    bonusBasePoints = _bonusBasePoints;
  }

  function isSane() public constant returns (bool) {
    return (token.mintAgents(address(this)) == true) && (token.releaseAgent() == address(this));
  }
/
  function finalizeCrowdsale() {
    if(msg.sender != address(crowdsale)) {
      throw;
    }

    uint tokensSold = crowdsale.tokensSold();
    allocatedBonus = tokensSold.times(bonusBasePoints) / 10000;

    token.mint(teamMultisig, allocatedBonus);

    // Make token transferable
    token.releaseTokenTransfer();
  }

}
