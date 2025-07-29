let display = document.getElementById('display');
let currentInput = '';
let currentOperator = '';
let previousInput = '';
let shouldResetDisplay = false;

function updateDisplay(value) {
    if (value.toString().length > 12) {
        display.textContent = parseFloat(value).toExponential(5);
    } else {
        display.textContent = value;
    }
}

function number(num) {
    if (shouldResetDisplay) {
        currentInput = '';
        shouldResetDisplay = false;
    }
    
    if (currentInput.length < 12) {
        currentInput = currentInput === '0' ? num : currentInput + num;
        updateDisplay(currentInput);
    }
}

function operator(op) {
    if (currentInput === '') return;
    
    if (previousInput !== '' && currentOperator !== '' && !shouldResetDisplay) {
        calculate();
    }
    
    currentOperator = op;
    previousInput = currentInput;
    shouldResetDisplay = true;
}

function calculate() {
    if (previousInput === '' || currentInput === '' || currentOperator === '') return;
    
    let result;
    const prev = parseFloat(previousInput);
    const current = parseFloat(currentInput);
    
    switch (currentOperator) {
        case '+':
            result = prev + current;
            break;
        case '-':
            result = prev - current;
            break;
        case '*':
            result = prev * current;
            break;
        case '/':
            if (current === 0) {
                alert('Cannot divide by zero');
                return;
            }
            result = prev / current;
            break;
        default:
            return;
    }
    
    currentInput = result.toString();
    currentOperator = '';
    previousInput = '';
    shouldResetDisplay = true;
    updateDisplay(result);
}

function clearAll() {
    currentInput = '';
    currentOperator = '';
    previousInput = '';
    shouldResetDisplay = false;
    updateDisplay('0');
}

function toggleSign() {
    if (currentInput !== '') {
        currentInput = currentInput.startsWith('-') 
            ? currentInput.slice(1) 
            : '-' + currentInput;
        updateDisplay(currentInput);
    }
}

function percentage() {
    if (currentInput !== '') {
        currentInput = (parseFloat(currentInput) / 100).toString();
        updateDisplay(currentInput);
    }
}

function decimal() {
    if (shouldResetDisplay) {
        currentInput = '0';
        shouldResetDisplay = false;
    }
    
    if (currentInput.indexOf('.') === -1) {
        currentInput += '.';
        updateDisplay(currentInput);
    }
}

function calculatorIcon() {
    // Calculator icon button - no action for now
    console.log('Calculator icon clicked');
}

// Keyboard support
document.addEventListener('keydown', function(event) {
    const key = event.key;
    
    if (key >= '0' && key <= '9') {
        number(key);
    } else if (key === '+' || key === '-' || key === '*' || key === '/') {
        operator(key);
    } else if (key === 'Enter' || key === '=') {
        calculate();
    } else if (key === 'Escape' || key === 'c' || key === 'C') {
        clearAll();
    } else if (key === '.') {
        decimal();
    } else if (key === '%') {
        percentage();
    }
});