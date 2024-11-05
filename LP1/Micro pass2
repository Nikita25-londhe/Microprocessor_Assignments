#include <iostream>
#include<vector>
#include<fstream>
#include<sstream>
using namespace std;
class Pass_02 {
    ifstream sy, li, fin;
    ofstream fout;
    vector<pair<string, int>> symtable;
    vector<pair<string, int>> littable;

public:
    void input() {
        sy.open("sym1.txt");
        li.open("lit.txt");
        fin.open("output.txt");
        fout.open("machine1.txt");
    }

    void generate() {
        string line = "", word = "";

        // Load Symbol Table
        while (getline(sy, line)) {
            stringstream ss(line);
            string label;
            int address;
            ss >> label >> word >> address; // Read the symbol number, symbol name (ignore), and address
            symtable.push_back({ word, address });
        }

        // Load Literal Table
        while (getline(li, line)) {
            stringstream ss(line);
            string label;
            int address;
            ss >> label >> address;
            littable.push_back({ label, address });
        }

        // Generate Machine Code from Intermediate Code
        while (getline(fin, line)) {
            stringstream ss(line);
            string location, opcode, operand;
            ss >> location >> opcode; // Read the location and opcode

            if (opcode == "(IS,") {
                string code;
                ss >> code;
                string instruction = code.substr(0, code.size() - 1); // Remove the closing parenthesis
                fout << location << " " << instruction << " "; // Write location and opcode to file

                while (ss >> word) {
                    if (word == "(S,") {
                        ss >> operand;
                        int symIndex = stoi(operand.substr(0, operand.size() - 1)) - 1;
                        fout << symtable[symIndex].second << " "; // Write symbol address
                    }
                    else if (word == "(L,") {
                        ss >> operand;
                        int litIndex = stoi(operand.substr(0, operand.size() - 1)) - 1;
                        fout << littable[litIndex].second << " "; // Write literal address
                    }
                    else if (word.find("(C,") != string::npos) {
                        fout << word.substr(0, word.size() - 1) << " "; // Write constant
                    }
                    else {
                        fout << word << " "; // Write register codes or anything else
                    }
                }
            }
            else if (opcode == "(DL,") {
                string directive;
                ss >> directive;
                if (directive == "01)") { // DC
                    ss >> word;
                    ss >> word;
                    fout << location << " 00 00 " << word.substr(0, word.size() - 1) << "\n"; // Write DC with constant
                }
                else if (directive == "02)") {
                    fout << location << " 00 00 00\n";
                }
            }
            fout << "\n"; // New line after each machine instruction
        }
    }

    void show() {
        cout << "\n===========Symbol table ==============" << endl;
        for (auto x : symtable) {
            cout << x.first << " " << x.second << "\n";
        }
        cout << "\n===========Literal table ===============" << endl;
        for (auto x : littable) {
            cout << x.first << " " << x.second << "\n";
        }
    }

    ~Pass_02() {
        sy.close();
        li.close();
        fin.close();
        fout.close();
    }
};

int main() {
    Pass_02 obj;
    obj.input();
    obj.generate();
    obj.show();
    return 0;
}
