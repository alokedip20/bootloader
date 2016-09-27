#include<iostream>
#include<sys/unistd.h>
#include<sys/wait.h>
#include<fstream>
#include<string>
#define SIZE 10
using namespace std;
int parse(string s[],string str){
	int k=0;
	string temp="";
        for(int i=0;i<str.length();i++){
                if(str[i]!=' '){
                        temp+=str[i];
                }
                else{
                        s[k]=temp;
                        temp="";
                        k++;
                }
        }
        s[k]=temp;
	return k+1;
}
int main()
{
	ifstream fin("make.txt");
	string line="";
	string str;
	string cmd[4];
	int k=0;
	int argc1,argc2,argc3,argc4;
	string s1[SIZE],s2[SIZE],s3[SIZE],s4[SIZE];
	string s[4][SIZE];
	char *argv1[SIZE],*argv2[SIZE],*argv3[SIZE],*argv4[SIZE];
	while (std::getline(fin, str))
	{
		line+= str;
		cmd[k++]=line;
		line="";
	}
	argc1=parse(s1,cmd[0]);
	argc2=parse(s2,cmd[1]);
	argc3=parse(s3,cmd[2]);
	argc4=parse(s4,cmd[3]);
	for(int i=0;i<argc1;i++){
		argv1[i]=const_cast<char*>(s1[i].c_str());
	}
	for(int i=0;i<argc2;i++){
                argv2[i]=const_cast<char*>(s2[i].c_str());
        }
	for(int i=0;i<argc3;i++){
                argv3[i]=const_cast<char*>(s3[i].c_str());
        }
	for(int i=0;i<argc4;i++){
                argv4[i]=const_cast<char*>(s4[i].c_str());
        }
	argv1[argc1]=(char*)NULL;
	argv2[argc2]=(char*)NULL;
	argv3[argc3]=(char*)NULL;
	argv4[argc4]=(char*)NULL;
	int pid;
	for(int i=0;i<4;i++){
		if((pid=fork())==0){
			if(i==0){
				cout<<"going to execute 1st command"<<endl;
				execvp(argv1[0],argv1);
				cout<<"can not execute 1st command"<<endl;
			}
			else if(i==1){
				cout<<"going to execute 2nd command"<<endl;
				execvp(argv2[0],argv2);
				cout<<"can not execute 2nd command"<<endl;
			}
			else if(i==2){
				cout<<"going to execute 3rd command"<<endl;
				execvp(argv3[0],argv3);
				cout<<"can not execute 3rd command"<<endl;
			}
			else{
				cout<<"going to execute 4th command"<<endl;
				execvp(argv4[0],argv4);
				cout<<"can not execute 4th command"<<endl;
			}
		}
		else
			wait(&pid);
	}
	fin.close();
}				
