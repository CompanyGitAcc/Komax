tableextension 59100 "TP Payroll Setup" extends "Payroll Setup"
{
    fields
    {
        field(50000; "Project Dimension Code"; Code[20])
        {
            Caption = 'Project Dimension Code';
            TableRelation = Dimension;
        }
        field(50001; "Working Hours Daily"; Decimal)
        {
            Caption = 'Working Hours Daily (Hour)';
        }
        field(50002; "Employee Dimension Code"; Code[20])
        {
            Caption = 'Employee Dimension Code';
            TableRelation = Dimension;
        }
        field(50003; "Department Dimension Code"; Code[20])
        {
            Caption = 'Department Dimension Code';
            TableRelation = Dimension;
        }
        field(50004; "Employee Nos."; Code[20])
        {
            Caption = 'Employee Nos.';
            TableRelation = "No. Series".Code;
        }
        field(50005; "Salary Item Nos."; Code[20])
        {
            Caption = 'Salary Item Nos.';
            TableRelation = "No. Series".Code;
        }
        field(50006; "Bank Salary Report ID"; Code[10])
        {
            Caption = 'Report ID';
        }
        field(50007; "Bank Salary Field No. 1"; Integer)
        {
            Caption = 'Field No. 1 (Bank Account No.)';
        }
        field(50008; "Bank Salary Field No. 2"; Integer)
        {
            Caption = 'Field No. 2 (Payable Amount)';
        }
        field(50009; "Tax Report ID"; Code[10])
        {
            Caption = 'Report ID';
        }
        field(50010; "Work Days per Month (Overtime)"; Decimal)
        {
            Caption = 'Work Days per Month (Overtime)';
        }
        field(50011; "Hours per Day"; Decimal)
        {
            Caption = 'Hours per Day';
        }


    }

}
