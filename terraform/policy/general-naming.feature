Feature: Naming Convention For General Azure Items

  @case_sensitive
  Scenario Outline: Naming Standard For Function API Manager
    Given I have <resource_name> defined
    When it has <name_key>
    Then it must have name
    Then its value must match the "apim-(dev|dev2|mvp|ppd|prd|prd1|prd2|stg|tst|tst1|tst2|uat).*" regex

    Examples:
      | resource_name          | name_key |
      | azurerm_api_management | name     |


  @case_sensitive
  Scenario Outline: Naming Standard For Function Resource Groups
    Given I have <resource_name> defined
    When it has <name_key>
    Then it must have name
    Then its value must match the "rg-.*(dev|dev2|mvp|ppd|prd|prd1|prd2|stg|tst|tst1|tst2|uat).*" regex

    Examples:
      | resource_name          | name_key |
      | azurerm_api_management | name     |

