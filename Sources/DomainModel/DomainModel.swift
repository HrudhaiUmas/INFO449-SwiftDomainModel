struct DomainModel
{
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money
{
    public let amount : Int;
    public let currency: String;
    
    // Doing what the hint says and will be using a USD based exchange rates
    private static let rates: [String : Double] =
    [
        "USD": 1.0,
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25
    ]
    
    public init(amount: Int, currency: String)
    {
        if Money.rates[currency] == nil
        {
            fatalError("\(currency) is an unknown currency");
        }
        else
        {
            self.amount = amount;
            self.currency = currency;
        }
    }
    
    public func convert(_ targetCurrency: String) -> Money
    {
        if Money.rates[self.currency] == nil
        {
            fatalError("Unknown source currency: \(self.currency)")
        }

        // check target currency
        if Money.rates[targetCurrency] == nil
        {
            fatalError("Unknown target currency: \(targetCurrency)")
        }
        
        let sourceCurrencyRate = Money.rates[self.currency]!;
        let targetCurrencyRate = Money.rates[targetCurrency]!;
        
        let amountInUSD = Double(self.amount) / sourceCurrencyRate;
        let convertedAmount = Int(amountInUSD * targetCurrencyRate);
        
        return Money(
            amount: convertedAmount,
            currency: targetCurrency
        )
    }
    
    public func add(_ moneyToAdd: Money) -> Money
    {
        let convertedMoneyToAdd = self.convert(moneyToAdd.currency);
        let totalAmount = moneyToAdd.amount + convertedMoneyToAdd.amount;
        
        return Money(
            amount: totalAmount,
            currency: moneyToAdd.currency
        )
    }
    
    public func subtract(_ moneyToSubtract: Money) -> Money
    {
        let convertedMoneyToSubtract = self.convert(moneyToSubtract.currency);
        let resultingAmount = convertedMoneyToSubtract.amount - moneyToSubtract.amount;
        
        return Money(
            amount: resultingAmount,
            currency: moneyToSubtract.currency
        )
    }
}

////////////////////////////////////
// Job
//
public class Job
{
    public enum JobType
    {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public let title: String;
    public var type: JobType;
    
    public init(title: String, type: JobType)
    {
        self.title = title;
        self.type = type;
    }
    
    public func calculateIncome(_ hours: Int) -> Int
    {
        var totalIncome = 0

        switch self.type
        {
            case JobType.Salary(let yearlyAmount):
                totalIncome = Int(yearlyAmount)

            case JobType.Hourly(let hourlyRate):
                let income = Double(hours) * hourlyRate
                totalIncome = Int(income)
        }

        return totalIncome
    }
    
    public func raise(byAmount amount: Double)
    {
        switch self.type
        {
            case .Salary(let yearlyAmount):
                self.type = JobType.Salary(UInt(Double(yearlyAmount) + amount))

            case .Hourly(let hourlyRate):
                self.type = JobType.Hourly(hourlyRate + amount)
        }
    }
    
    public func raise(byPercent percent: Double)
    {
        switch self.type
        {
            case .Salary(let yearlyAmount):
                self.type = JobType.Salary(UInt(Double(yearlyAmount) * (1.0 + percent)))

            case .Hourly(let hourlyRate):
                self.type = JobType.Hourly(hourlyRate * (1.0 + percent))
        }
    }


}

////////////////////////////////////
// Person
//
public class Person
{
    
}

////////////////////////////////////
// Family
//
public class Family
{
    
}
