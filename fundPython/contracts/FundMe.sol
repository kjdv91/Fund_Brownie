
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

//importaciones
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";



// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract FundMe{

    address public owner;  //variables de estado
    address [] public founders;  //arreglo dinamico de los funders
    //mapping ingreso una address y puedo ver la cantidad que envio en found
    mapping(address => uint256) public  addressToAmountFunded;
    using SafeMathChainlink for uint256; //problema de overflow 

    

    
    
    //function modifier

    modifier onlyOwner{
        require(msg.sender == owner); //solo el owner
        _;
    }
    
    AggregatorV3Interface public priceFeed;  //inicializando
    //constructor
    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);

        owner = msg.sender;  //dueno del contrato
    } 



    function fund()public payable{
        uint256 minimunUSD = 50 * 10 **18;  //minimo deposito es de 50 dolares
        require(getConversionRate(msg.value) >= minimunUSD, "Necesitas depositar + eth");  //minimo deposito 
        addressToAmountFunded[msg.sender] += msg.value;  //suma en 1 los funders
        founders.push(msg.sender); //agg cada funder en el mapping
        
        }

    function getVersion()public view returns(uint256){
       
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        ( ,int price,,,) = priceFeed.latestRoundData(); //tupla
        return uint256(price * 10000000000);  //convierto de int a uint256


    }

    function getEntrancefee() public view returns(uint256){
        uint256 minimuUSD = 50 * 10 **18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10 **18;
        return((minimuUSD * precision) / price) +1;
    }

    //funcion de conversion de gwei a eth sin ceros
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;

    }

    //funcion de retiro
    function withdraw ()payable onlyOwner public  {  //solo el dueno del contrato puede ejecutar esdta funcion
        msg.sender.transfer(address(this).balance);  ///transfer permite transferir activos 
        //this este contrato y balance es el balance del contrato

        //vacias los founders
        for(uint256 foundersIndex; foundersIndex < founders.length; foundersIndex ++ ){
            address founder = founders[foundersIndex]; //addres es en la variables
            addressToAmountFunded[founder] = 0;  //mapping vacia el founder

        }
        founders = new address[](0); //se vacia el array founders nuevo array

    }





    
}

