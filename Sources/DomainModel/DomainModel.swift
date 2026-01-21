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
    public let firstName: String
    public let lastName: String
    public let age: Int

    private var storedJob: Job?
    private var storedSpouse: Person?

    public var job: Job?
    {
        get
        {
            return storedJob
        }
        set
        {
            if self.age >= 16
            {
                storedJob = newValue
            }
        }
    }

    public var spouse: Person?
    {
        get
        {
            return storedSpouse
        }
        set
        {
            if self.age >= 18
            {
                storedSpouse = newValue
            }
        }
    }

    public init(firstName: String, lastName: String, age: Int)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.storedJob = nil
        self.storedSpouse = nil
    }

    public func toString() -> String
    {
        let jobString: String
        if let currentJob = self.job
        {
            switch currentJob.type
            {
                case .Salary(let amount):
                    jobString = "Salary(\(amount))"
                case .Hourly(let rate):
                    jobString = "Hourly(\(rate))"
            }
        }
        else
        {
            jobString = "nil"
        }

        let spouseString: String
        if let currentSpouse = self.spouse
        {
            spouseString = currentSpouse.firstName
        }
        else
        {
            spouseString = "nil"
        }

        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(jobString) spouse:\(spouseString)]"
    }
}

////////////////////////////////////
// Family
//
public class Family
{
    public var members: [Person]

    public init(spouse1: Person, spouse2: Person)
    {
        self.members = []

        // making sure neither person already has a spouse
        if spouse1.spouse == nil && spouse2.spouse == nil
        {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }

        self.members.append(spouse1)
        self.members.append(spouse2)
    }

    public func haveChild(_ child: Person) -> Bool
    {
        // checking if at least one spouse is over 21
        let spouse1 = self.members[0]
        let spouse2 = self.members[1]

        if spouse1.age > 21 || spouse2.age > 21
        {
            self.members.append(child)
            return true
        }

        return false
    }

    public func householdIncome() -> Int
    {
        var totalIncome = 0

        for person in self.members
        {
            if let currentJob = person.job
            {
                totalIncome += currentJob.calculateIncome(2000)
            }
        }

        return totalIncome
    }
}
