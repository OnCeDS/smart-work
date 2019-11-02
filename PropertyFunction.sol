pragma solidity >=0.4.0 < 0.6.0;
  contract PropertyS {
    mapping(uint=>address) numderToAddress;
    /* МОДИФИКАТОРЫ */
    /* Система защиты */
    modifier isOwner(uint id) {
    require(msg.sender == numberToAddress[id], " Access error ");
    _;
    }
    
    /* Создание свойст недвижимости */
    struct Property {
      uint s;
      uint effectiveArea;
      bool encumbrances;
     }
    struct Advertisement {
      uint id;
      uint propertyNum;
      uint price;
      address owner;
      bool active;
     }
     /* Хранение недвижимостей */
     Property[] propertys;
     /* Хранение рекламных объявлений */
       function payTo(address to, uint value) public payable{
            require(msg.value > value);
            address payable addr = address(uint160(to));
            addr.transfer(value);
        }
    
        /* Функция создания недвижимости */
        function createProperty (uint s, uint effectiveArea, address owner, bool encumbrances) external{
            Property memory call = Property(s, effectiveArea, encumbrances);
            uint id = propertys.push(call);
            numderToAddress[id] = owner; 
            
        }
        
        /* Функция просмотра недвижимости */
        function viewProperty(uint s) external view returns (address, bool, uint, uint) {
            Property memory calling = propertys[s];
            return(numderToAddress[s], calling.encumbrances, calling.s, calling.effectiveArea);
            
        
        }
        
        /* передача недвижимости другому лицу */
        function transferProperty(uint s, address recipient) external isOwner(s){
            numderToAddress[s] = recipient;
            
        }
        
        function createAd (uint id, uint propertyNum, uint price ) public isOwner(id){
            Advertisement memory call = Advertisement(id, propertyNum, price, msg.sender, true);
            advertisements.push(call);
            
        }
        
        /* продажа недвижимости другому лицу */
        function sellProperty(uint s) external {
            require(advertisements[s].active == true, " House was sold "); 
            payTo(advertisements[s].owner, advertisements[s].price);
            advertisements[s].active = false;
            numderToAddress[advertisements[s].id] = msg.sender;
            
        }
