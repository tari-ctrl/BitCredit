;; Title: BitCredit - Decentralized Credit & Lending Protocol

;; Summary: 
;; A trustless, collateralized lending protocol built on Stacks that enables
;; users to establish on-chain credit scores, borrow STX tokens, and build
;; their creditworthiness within a decentralized financial ecosystem.

;; Description:
;; BitCredit is a decentralized finance protocol that introduces credit scoring
;; and lending to the Bitcoin ecosystem via Stacks. The contract manages:
;;
;; 1. User credit profiles with dynamic scoring (50-100)
;; 2. Collateralized loans with interest rates based on credit scores
;; 3. Loan lifecycle (creation, repayment, default management)
;; 4. Automated credit score adjustments based on repayment behavior
;;
;; The protocol incentivizes positive financial behavior by reducing collateral
;; requirements and interest rates for users with higher credit scores, while
;; maintaining the security benefits of blockchain technology.

;; Contract administration
(define-constant CONTRACT-OWNER tx-sender)

;; Error codes
(define-constant ERR-UNAUTHORIZED (err u1))
(define-constant ERR-INSUFFICIENT-BALANCE (err u2))
(define-constant ERR-INVALID-AMOUNT (err u3))
(define-constant ERR-LOAN-NOT-FOUND (err u4))
(define-constant ERR-LOAN-DEFAULTED (err u5))
(define-constant ERR-INSUFFICIENT-SCORE (err u6))
(define-constant ERR-ACTIVE-LOAN (err u7))
(define-constant ERR-NOT-DUE (err u8))
(define-constant ERR-INVALID-DURATION (err u9))
(define-constant ERR-INVALID-LOAN-ID (err u10))

;; Credit score configuration
(define-constant MIN-SCORE u50) ;; Minimum possible credit score
(define-constant MAX-SCORE u100) ;; Maximum possible credit score
(define-constant MIN-LOAN-SCORE u70) ;; Minimum score required for loan eligibility

;; Data Maps

;; Stores user credit profiles
(define-map UserScores
  { user: principal }
  {
    score: uint, ;; Current credit score (50-100)
    total-borrowed: uint, ;; Lifetime amount borrowed
    total-repaid: uint, ;; Lifetime amount repaid
    loans-taken: uint, ;; Count of total loans taken
    loans-repaid: uint, ;; Count of loans successfully repaid
    last-update: uint, ;; Block height of last update
  }
)

;; Stores individual loan data
(define-map Loans
  { loan-id: uint }
  {
    borrower: principal, ;; Loan recipient
    amount: uint, ;; Principal amount in STX
    collateral: uint, ;; Collateral amount in STX
    due-height: uint, ;; Block height when loan is due
    interest-rate: uint, ;; Interest rate in percentage
    is-active: bool, ;; Whether loan is currently active
    is-defaulted: bool, ;; Whether loan has defaulted
    repaid-amount: uint, ;; Amount repaid so far
  }
)

;; Maps users to their active loans
(define-map UserLoans
  { user: principal }
  { active-loans: (list 20 uint) } ;; List of active loan IDs, max 20
)

;; Variables

;; Auto-incrementing loan ID counter
(define-data-var next-loan-id uint u0)

;; Tracks total STX locked as collateral
(define-data-var total-stx-locked uint u0)

;; Public Functions

;; Initialize a new user's credit score
;; Creates a new credit profile for the caller with the minimum score
(define-public (initialize-score)
  (let ((sender tx-sender))
    (asserts! (is-none (map-get? UserScores { user: sender })) ERR-UNAUTHORIZED)
    (ok (map-set UserScores { user: sender } {
      score: MIN-SCORE,
      total-borrowed: u0,
      total-repaid: u0,
      loans-taken: u0,
      loans-repaid: u0,
      last-update: stacks-block-height,
    }))
  )
)