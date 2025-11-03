# Flutter UI Component Package - LLM Agent Guide

This document serves as a comprehensive guide for Large Language Models (LLMs) to understand and generate valid JSON configurations for the Flutter UI Component package. The package provides JSON-driven UI rendering capabilities using `json_dynamic_widget` with custom Uber Base Design System components.

## Overview

The Flutter UI Component package provides five core UI components that can be rendered dynamically from JSON:
1. **UberTextButton** - Lightweight buttons for secondary actions
2. **UberElevatedButton** - Primary action buttons with elevation
3. **UberAmountInput** - Specialized input field for currency amounts  
4. **UberTextInput** - Versatile text input fields for various data types
5. **UberRadio** - Single selection radio buttons with list tile support

## LLM Workflow Instructions

### Step 1: Document Analysis
When a user requests UI generation:
1. **Request the design document** (PDF, DOCX, or text description)
2. **Analyze the document** for:
   - Layout requirements and structure
   - Component types needed (buttons, inputs, selections)
   - Styling preferences (colors, sizes, variants)
   - User interaction flows
   - Accessibility requirements

### Step 2: JSON Generation
Based on the document analysis:
1. **Choose appropriate components** from the available set
2. **Structure the layout** using standard Flutter widgets (Column, Row, Container, etc.)
3. **Configure component properties** according to design specifications
4. **Implement user interactions** using predefined action types
5. **Ensure accessibility** with proper semantic labels

### Step 3: Validation
Before providing the JSON:
1. **Verify JSON syntax** is valid
2. **Check component types** are correctly spelled
3. **Ensure required properties** are included
4. **Validate action handlers** are properly defined

## Component Documentation

### 1. UberTextButton

**Type:** `uber_text_button`

**Description:** Lightweight button component for secondary actions with hover and focus states.

**Required Properties:**
- `label` (string): Button text content

**Optional Properties:**
- `variant` (string): Button style variant
  - `"primary"` (default): Primary brand color
  - `"secondary"`: Secondary brand color  
  - `"destructive"`: Error/danger color
- `size` (string): Button size
  - `"small"`: Compact size for tight spaces
  - `"medium"` (default): Standard size
  - `"large"`: Prominent size for primary actions
- `onPressed` (string): Action to perform when pressed
- `isLoading` (boolean): Show loading indicator (default: false)
- `enabled` (boolean): Enable/disable button (default: true)
- `fullWidth` (boolean): Expand to full container width (default: false)
- `semanticLabel` (string): Accessibility label for screen readers

**JSON Example:**
```json
{
  "type": "uber_text_button",
  "args": {
    "label": "Continue",
    "variant": "primary",
    "size": "medium",
    "onPressed": "show_snackbar",
    "semanticLabel": "Continue to next step"
  }
}
```

**Use Cases:**
- Secondary navigation actions
- Cancel/dismiss buttons
- Link-style buttons
- Toolbar actions

---

### 2. UberElevatedButton

**Type:** `uber_elevated_button`

**Description:** Primary action button with elevation and shadow effects for emphasis.

**Required Properties:**
- `label` (string): Button text content

**Optional Properties:**
- `variant` (string): Button style variant
  - `"primary"` (default): Primary brand color with white text
  - `"secondary"`: Secondary container color
  - `"destructive"`: Error color for dangerous actions
- `size` (string): Button size
  - `"small"`: Compact elevated button
  - `"medium"` (default): Standard elevated button
  - `"large"`: Prominent elevated button
- `onPressed` (string): Action to perform when pressed
- `isLoading` (boolean): Show loading indicator (default: false)
- `enabled` (boolean): Enable/disable button (default: true)
- `fullWidth` (boolean): Expand to full container width (default: false)
- `semanticLabel` (string): Accessibility label for screen readers

**JSON Example:**
```json
{
  "type": "uber_elevated_button",
  "args": {
    "label": "Submit Form",
    "variant": "primary",
    "size": "large",
    "fullWidth": true,
    "onPressed": "submit_form",
    "semanticLabel": "Submit the registration form"
  }
}
```

**Use Cases:**
- Primary call-to-action buttons
- Form submission buttons
- Confirmation actions
- Main navigation actions

---

### 3. UberAmountInput

**Type:** `uber_amount_input`

**Description:** Specialized input field for currency amounts with built-in validation and formatting.

**Required Properties:**
None (all properties are optional)

**Optional Properties:**
- `label` (string): Field label text
- `hintText` (string): Placeholder text
- `helperText` (string): Help text below the field
- `errorText` (string): Error message to display
- `initialValue` (number): Pre-filled amount value
- `currency` (string): Currency symbol (default: "$")
- `minAmount` (number): Minimum allowed amount
- `maxAmount` (number): Maximum allowed amount
- `maxDecimalPlaces` (number): Maximum decimal places (default: 2)
- `enabled` (boolean): Enable/disable input (default: true)
- `semanticLabel` (string): Accessibility label for screen readers

**JSON Example:**
```json
{
  "type": "uber_amount_input",
  "args": {
    "label": "Monthly Budget",
    "hintText": "Enter your monthly budget",
    "helperText": "Minimum $100 required",
    "currency": "$",
    "minAmount": 100,
    "maxAmount": 10000,
    "maxDecimalPlaces": 2,
    "semanticLabel": "Enter your monthly budget amount"
  }
}
```

**Use Cases:**
- Price inputs
- Budget fields
- Payment amounts
- Financial calculations

---

### 4. UberTextInput

**Type:** `uber_text_input`

**Description:** Versatile text input field supporting multiple input types and validation.

**Required Properties:**
None (all properties are optional)

**Optional Properties:**
- `label` (string): Field label text
- `hintText` (string): Placeholder text
- `helperText` (string): Help text below the field
- `errorText` (string): Error message to display
- `initialValue` (string): Pre-filled text value
- `type` (string): Input type
  - `"text"` (default): Standard text input
  - `"email"`: Email input with validation
  - `"password"`: Password input with visibility toggle
  - `"multiline"`: Multi-line text area
- `maxLength` (number): Maximum character limit
- `maxLines` (number): Maximum number of lines
- `minLines` (number): Minimum number of lines
- `enabled` (boolean): Enable/disable input (default: true)
- `textAlign` (string): Text alignment ("start", "center", "right", "justify")
- `textCapitalization` (string): Text capitalization ("none", "words", "sentences", "characters")
- `semanticLabel` (string): Accessibility label for screen readers

**JSON Example:**
```json
{
  "type": "uber_text_input",
  "args": {
    "label": "Full Name",
    "hintText": "Enter your full name",
    "type": "text",
    "textCapitalization": "words",
    "maxLength": 50,
    "semanticLabel": "Enter your full name"
  }
}
```

**Advanced Examples:**
```json
{
  "type": "uber_text_input",
  "args": {
    "label": "Email Address",
    "hintText": "you@example.com",
    "type": "email",
    "semanticLabel": "Enter your email address"
  }
}
```

```json
{
  "type": "uber_text_input",
  "args": {
    "label": "Comments",
    "hintText": "Share your thoughts...",
    "type": "multiline",
    "minLines": 3,
    "maxLines": 6,
    "maxLength": 500,
    "semanticLabel": "Enter your comments"
  }
}
```

**Use Cases:**
- User registration forms
- Contact information
- Search fields
- Comments and feedback
- Multi-line descriptions

---

### 5. UberRadio

**Type:** `uber_radio` or `uber_radio_list_tile`

**Description:** Single selection radio buttons for choosing one option from multiple choices.

#### Basic Radio Button (`uber_radio`)

**Required Properties:**
- `value` (string): The value this radio represents
- `groupValue` (string): Currently selected value in the group

**Optional Properties:**
- `enabled` (boolean): Enable/disable radio (default: true)
- `semanticLabel` (string): Accessibility label for screen readers

#### Radio List Tile (`uber_radio_list_tile`)

**Required Properties:**
- `value` (string): The value this radio represents
- `groupValue` (string): Currently selected value in the group

**Optional Properties:**
- `title` (string): Main label text
- `subtitle` (string): Secondary description text
- `enabled` (boolean): Enable/disable radio (default: true)
- `semanticLabel` (string): Accessibility label for screen readers

**JSON Examples:**

Basic Radio Group:
```json
{
  "type": "column",
  "children": [
    {
      "type": "text",
      "args": {
        "data": "Choose your plan:"
      }
    },
    {
      "type": "row",
      "children": [
        {
          "type": "uber_radio",
          "args": {
            "value": "basic",
            "groupValue": "basic",
            "semanticLabel": "Basic plan option"
          }
        },
        {
          "type": "text",
          "args": {
            "data": "Basic Plan"
          }
        }
      ]
    }
  ]
}
```

Radio List Tiles (Recommended):
```json
{
  "type": "column",
  "children": [
    {
      "type": "uber_radio_list_tile",
      "args": {
        "value": "basic",
        "groupValue": "basic",
        "title": "Basic Plan",
        "subtitle": "Perfect for getting started - $9.99/month",
        "semanticLabel": "Select basic plan"
      }
    },
    {
      "type": "uber_radio_list_tile",
      "args": {
        "value": "premium",
        "groupValue": "basic",
        "title": "Premium Plan", 
        "subtitle": "Full access to all features - $29.99/month",
        "semanticLabel": "Select premium plan"
      }
    }
  ]
}
```

**Use Cases:**
- Plan selection
- Preference settings
- Survey questions
- Configuration options

---

## Action Handlers

The following action handlers are available for button `onPressed` events:

- `"show_snackbar"`: Display a confirmation message
- `"navigate_back"`: Navigate to previous screen
- Custom actions can be added as needed

## Layout Components

You can use standard Flutter layout widgets to structure your UI:

### Column
```json
{
  "type": "column",
  "args": {
    "crossAxisAlignment": "start",
    "mainAxisAlignment": "center",
    "mainAxisSize": "min"
  },
  "children": [...]
}
```

### Row
```json
{
  "type": "row",
  "args": {
    "crossAxisAlignment": "center",
    "mainAxisAlignment": "spaceBetween"
  },
  "children": [...]
}
```

### Container
```json
{
  "type": "container",
  "args": {
    "padding": {
      "top": 16,
      "bottom": 16,
      "left": 24,
      "right": 24
    },
    "margin": {
      "all": 8
    }
  },
  "child": {...}
}
```

### SizedBox (Spacing)
```json
{
  "type": "sized_box",
  "args": {
    "height": 16,
    "width": 100
  }
}
```

### Wrap (Responsive Layout)
```json
{
  "type": "wrap",
  "args": {
    "spacing": 8,
    "runSpacing": 8,
    "alignment": "center"
  },
  "children": [...]
}
```

## Complete Example Templates

### 1. User Registration Form
```json
{
  "type": "container",
  "args": {
    "padding": {
      "all": 24
    }
  },
  "child": {
    "type": "column",
    "args": {
      "crossAxisAlignment": "stretch",
      "mainAxisSize": "min"
    },
    "children": [
      {
        "type": "text",
        "args": {
          "data": "Create Your Account",
          "style": {
            "fontSize": 24,
            "fontWeight": "bold"
          }
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 24
        }
      },
      {
        "type": "uber_text_input",
        "args": {
          "label": "Full Name",
          "hintText": "Enter your full name",
          "type": "text",
          "textCapitalization": "words"
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 16
        }
      },
      {
        "type": "uber_text_input",
        "args": {
          "label": "Email",
          "hintText": "you@example.com",
          "type": "email"
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 16
        }
      },
      {
        "type": "uber_text_input",
        "args": {
          "label": "Password",
          "hintText": "Choose a secure password",
          "type": "password"
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 24
        }
      },
      {
        "type": "uber_elevated_button",
        "args": {
          "label": "Create Account",
          "variant": "primary",
          "fullWidth": true,
          "onPressed": "show_snackbar"
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 12
        }
      },
      {
        "type": "uber_text_button",
        "args": {
          "label": "Already have an account? Sign in",
          "variant": "secondary",
          "fullWidth": true,
          "onPressed": "navigate_back"
        }
      }
    ]
  }
}
```

### 2. Settings Panel
```json
{
  "type": "container",
  "args": {
    "padding": {
      "all": 24
    }
  },
  "child": {
    "type": "column",
    "args": {
      "crossAxisAlignment": "start",
      "mainAxisSize": "min"
    },
    "children": [
      {
        "type": "text",
        "args": {
          "data": "Notification Settings",
          "style": {
            "fontSize": 20,
            "fontWeight": "bold"
          }
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 20
        }
      },
      {
        "type": "uber_radio_list_tile",
        "args": {
          "value": "all",
          "groupValue": "email_only",
          "title": "All Notifications",
          "subtitle": "Receive all app notifications"
        }
      },
      {
        "type": "uber_radio_list_tile",
        "args": {
          "value": "email_only",
          "groupValue": "email_only",
          "title": "Email Only",
          "subtitle": "Only receive email notifications"
        }
      },
      {
        "type": "uber_radio_list_tile",
        "args": {
          "value": "none",
          "groupValue": "email_only",
          "title": "No Notifications", 
          "subtitle": "Turn off all notifications"
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 32
        }
      },
      {
        "type": "row",
        "args": {
          "mainAxisAlignment": "end"
        },
        "children": [
          {
            "type": "uber_text_button",
            "args": {
              "label": "Cancel",
              "variant": "secondary",
              "onPressed": "navigate_back"
            }
          },
          {
            "type": "sized_box",
            "args": {
              "width": 12
            }
          },
          {
            "type": "uber_elevated_button",
            "args": {
              "label": "Save Settings",
              "variant": "primary",
              "onPressed": "show_snackbar"
            }
          }
        ]
      }
    ]
  }
}
```

### 3. Payment Form
```json
{
  "type": "container",
  "args": {
    "padding": {
      "all": 24
    }
  },
  "child": {
    "type": "column",
    "args": {
      "crossAxisAlignment": "stretch",
      "mainAxisSize": "min"
    },
    "children": [
      {
        "type": "text",
        "args": {
          "data": "Payment Information",
          "style": {
            "fontSize": 20,
            "fontWeight": "bold"
          }
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 20
        }
      },
      {
        "type": "uber_amount_input",
        "args": {
          "label": "Amount",
          "hintText": "Enter payment amount",
          "currency": "$",
          "minAmount": 1,
          "maxAmount": 10000
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 16
        }
      },
      {
        "type": "uber_text_input",
        "args": {
          "label": "Card Number",
          "hintText": "1234 5678 9012 3456",
          "type": "text"
        }
      },
      {
        "type": "sized_box",
        "args": {
          "height": 16
        }
      },
      {
        "type": "row",
        "children": [
          {
            "type": "expanded",
            "child": {
              "type": "uber_text_input",
              "args": {
                "label": "Expiry",
                "hintText": "MM/YY",
                "type": "text"
              }
            }
          },
          {
            "type": "sized_box",
            "args": {
              "width": 16
            }
          },
          {
            "type": "expanded",
            "child": {
              "type": "uber_text_input",
              "args": {
                "label": "CVV",
                "hintText": "123",
                "type": "text"
              }
            }
          }
        ]
      },
      {
        "type": "sized_box",
        "args": {
          "height": 24
        }
      },
      {
        "type": "uber_elevated_button",
        "args": {
          "label": "Process Payment",
          "variant": "primary",
          "fullWidth": true,
          "onPressed": "show_snackbar"
        }
      }
    ]
  }
}
```

## Best Practices for LLMs

1. **Always include semantic labels** for accessibility
2. **Use consistent spacing** with SizedBox components  
3. **Structure layouts logically** with Column/Row hierarchy
4. **Choose appropriate button variants** based on action importance
5. **Validate inputs** with proper min/max values for amounts
6. **Group related radio options** with consistent groupValue
7. **Use descriptive labels and hints** for better UX
8. **Consider responsive design** with Wrap for multiple items
9. **Test JSON syntax** before providing to users
10. **Provide fallback content** for empty states

## Error Handling

Common issues and solutions:

- **Invalid JSON syntax**: Use proper quotes and comma placement
- **Unknown widget type**: Verify component names match exactly
- **Missing required properties**: Include all required args
- **Invalid property values**: Check enum values (variants, sizes, types)
- **Layout issues**: Ensure proper parent-child relationships

## Extending the System

To add new components:
1. Create a new JsonWidgetBuilder class
2. Register it in UberJsonWidgetBuilders.builders
3. Document the component in this guide
4. Add examples and use cases
5. Update the JSON preview screen examples

This guide enables LLMs to generate sophisticated, accessible UI layouts using the Flutter UI Component package's JSON rendering capabilities.