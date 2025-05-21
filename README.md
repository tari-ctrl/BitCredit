# BitCredit - Decentralized Credit & Lending Protocol

**BitCredit** is a decentralized, trustless lending protocol built on the [Stacks](https://www.stacks.co/) blockchain. It introduces on-chain credit scoring, collateralized loan management, and financial behavior incentives to the Bitcoin ecosystem.

## 📜 Summary

BitCredit allows users to:

* Establish on-chain **credit scores** (ranging from 50 to 100)
* Request **collateralized loans** in STX based on their credit score
* **Repay** loans partially or fully, with automatic credit score adjustments
* Build a **trustless credit history** on-chain

The protocol rewards responsible repayment behavior with lower interest rates and reduced collateral requirements.

## 🏗️ Architecture Overview

### Core Components

| Component           | Description                                                                       |
| ------------------- | --------------------------------------------------------------------------------- |
| `UserScores`        | Tracks user credit profiles, including credit score and loan history.             |
| `Loans`             | Manages individual loan records with repayment, collateral, and interest details. |
| `UserLoans`         | Maps each user to their active loan IDs (up to 20 concurrent).                    |
| `Public Functions`  | Allow users to initialize profiles, request loans, and make repayments.           |
| `Admin Functions`   | Enables contract owner to mark loans as defaulted after due date.                 |
| `Private Functions` | Internal logic to calculate interest, collateral, update scores, and track loans. |

### Credit Score-Based Incentives

* **High Score (closer to 100)**:

  * Lower collateral ratio
  * Lower interest rate
* **Low Score (closer to 50)**:

  * Higher collateral requirement
  * Higher interest rate

## 📦 Installation

To deploy or test the BitCredit smart contract, use the [Clarinet](https://docs.stacks.co/write-smart-contracts/clarinet) CLI:

```bash
clarinet check       # Lint the contract
clarinet test        # Run unit tests
clarinet console     # Interact with the contract
```

Ensure your development environment includes:

* Stacks blockchain environment
* Clarinet installed locally
* Testnet STX tokens (for testing transfers and loans)

---

## 🚀 Usage

### 1. Initialize Credit Score

```clojure
(tx-sender 'initialize-score)
```

Creates a new profile with a starting credit score of 50.

### 2. Request a Loan

```clojure
(request-loan u100 u150 u1000)
;; amount: 100 STX
;; collateral: 150 STX
;; duration: ~7 days (assuming 10-min block time)
```

Validates user eligibility and transfers the loan if collateral and score are sufficient.

### 3. Repay a Loan

```clojure
(repay-loan u1 u110)
;; loan-id: 1
;; amount: 110 STX (covers principal + interest)
```

Updates loan status and credit score if fully repaid.

### 4. Mark Loan as Defaulted

Admin-only function:

```clojure
(mark-loan-defaulted u1)
```

Can only be called after the loan due block height has passed.

---

## 🔐 Security & Limitations

* Only users with a minimum score of `70` can request loans.
* Contract enforces **collateralization**, **repayment timelines**, and **score-based incentives**.
* Admin rights (`CONTRACT-OWNER`) are required to mark loans as defaulted.
* Maximum of 20 active loans per user.

---

## 📊 Data Flow Summary

```text
User → initialize-score → [UserScores]
     → request-loan → [UserScores, Loans, UserLoans]
     → repay-loan → [Loans, UserScores]
     → mark-loan-defaulted (admin) → [Loans, UserScores]
```

---

## 🧠 Future Enhancements

* Integration with off-chain identity or KYC providers
* Credit score portability across dApps
* NFT or tokenized representation of credit profiles
* Integration with Bitcoin L2 for cross-chain liquidity

## 🛠️ Contract Constants Overview

| Constant         | Value | Description                          |
| ---------------- | ----- | ------------------------------------ |
| `MIN-SCORE`      | 50    | Minimum possible user credit score   |
| `MAX-SCORE`      | 100   | Maximum possible credit score        |
| `MIN-LOAN-SCORE` | 70    | Score threshold for requesting loans |
| `BASE-RATE`      | 10    | Base interest rate before discounts  |

## 🤝 Contributing

Pull requests and suggestions are welcome! For major changes, open an issue first to discuss your ideas.
