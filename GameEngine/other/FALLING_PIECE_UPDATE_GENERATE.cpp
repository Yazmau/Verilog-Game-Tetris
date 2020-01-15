#include<bits/stdc++.h>
using namespace std;
struct pos {
	int delta_i,delta_j;
};
vector<string> tab = {"    "};
const int st = 2;
int main() {
	ios::sync_with_stdio(0);
	cin.tie(0);
	
    vector<vector<pos> > Q = {{{0,1},{0,2},{1,1},{1,2}},{{0,1},{0,2},{1,1},{1,2}},{{0,1},{0,2},{1,1},{1,2}},{{0,1},{0,2},{1,1},{1,2}}};
	vector<vector<pos> > S = {{{0,1},{0,2},{1,0},{1,1}},{{0,1},{1,1},{1,2},{2,2}},{{1,1},{1,2},{2,0},{2,1}},{{0,0},{1,0},{1,1},{2,1}}};
	vector<vector<pos> > Z = {{{0,0},{0,1},{1,1},{1,2}},{{0,2},{1,1},{1,2},{2,1}},{{1,0},{1,1},{2,1},{2,2}},{{0,1},{1,0},{1,1},{2,0}}};
	vector<vector<pos> > T = {{{0,1},{1,0},{1,1},{1,2}},{{0,1},{1,1},{1,2},{2,1}},{{1,0},{1,1},{1,2},{2,1}},{{0,1},{1,0},{1,1},{2,1}}};
	vector<vector<pos> > L = {{{0,2},{1,0},{1,1},{1,2}},{{0,1},{1,1},{2,1},{2,2}},{{1,0},{1,1},{1,2},{2,0}},{{0,0},{0,1},{1,1},{2,1}}};
	vector<vector<pos> > J = {{{0,0},{1,0},{1,1},{1,2}},{{0,1},{0,2},{1,1},{2,1}},{{1,0},{1,1},{1,2},{2,2}},{{0,1},{1,1},{2,0},{2,1}}};
	vector<vector<pos> > I = {{{1,0},{1,1},{1,2},{1,3}},{{0,2},{1,2},{2,2},{3,2}},{{2,0},{2,1},{2,2},{2,3}},{{0,1},{1,1},{2,1},{3,1}}};
	
	vector<vector<vector<pos> > > tetris{Q,S,Z,T,L,J,I};
	string name = "QSZTLJI";
	
	// 七種方塊的各角度呈現 
	/*
	int rotation_print_idx = 0;
	for(auto type : tetris) {
		const int h = 4 , w = 4 * 4 + 3;
		char board[h][w];
		for(int i=0;i<h;i++)
			for(int j=0;j<w;j++)
				board[i][j] = ((j + 1) % 5 == 0) ? ' ' : '.';
		int fix = 0;
		for(auto angle : type) {
			for(pos d : angle)
				board[d.delta_i][d.delta_j + fix] = 'O';
			fix += 5;
		}
		
		cout << name[rotation_print_idx] << " :" << endl;
		for(int i=0;i<h;i++) {
			for(int j=0;j<w;j++)
				cout << board[i][j];
			cout << endl;
		}
		cout << endl << endl;
		rotation_print_idx++;
	}
	return 0;
	*/
	
	for(int i=0;i<20;i++)	tab.emplace_back(tab.back() + tab.front());
	
	cout << tab[st+0] << "CHECK_STATE: begin" << endl;
	cout << tab[st+1] << "case(op_type)" << endl;	// op_type
	for(auto op_case : {make_tuple("`LEFT_MOVE_OP","+ 0","- 1",0),make_tuple("`RIGHT_MOVE_OP","+ 0","+ 1",0),
							make_tuple("`DOWN_MOVE_OP","+ 1","+ 0",0),make_tuple("`SPIN_OP","+ 0","+ 0",1)}) {
		cout << tab[st+2] << get<0>(op_case) << ": begin" << endl;
		cout << tab[st+3] << "case(falling_piece_type)" << endl;	// type of falling piece
		for(int type_t = 0 ; type_t < 7 ; type_t++) {
			cout << tab[st+4] << "`" << name[type_t] << "_PIECE: begin" << endl;
			cout << tab[st+5] << "case(falling_piece_angle)" << endl;	// angle of falling_piece
			for(int angle_t = 0 ; angle_t < 4; angle_t++) {
				cout << tab[st+6] << "2'd" << angle_t << ": begin" << endl;
				cout << tab[st+7] << "case(cnt)" << endl;	// cnt (check by order)
				for(int cnt_t = 0 ; cnt_t < 6 ; cnt_t++) {
					cout << tab[st+8] << "4'd" << cnt_t << ": begin" << endl;
					
					if(cnt_t < 4) {
						pos now = tetris[type_t][(angle_t+get<3>(op_case)+4)%4][cnt_t];
						cout << tab[st+9] << "pos_i = falling_piece_i " << get<1>(op_case) << " + " << now.delta_i << ";" << endl;	
						cout << tab[st+9] << "pos_j = falling_piece_j " << get<2>(op_case) << " + " << now.delta_j << ";" << endl;	
					}
					else if(cnt_t == 5) {
						cout << tab[st+9] << "next_state = (valid == 1'b1) ? UPDATE_STATE : WAIT_STATE;" << endl;
					}
					
					if(cnt_t < 5) {
						cout << tab[st+9] << "next_cnt = cnt + 1'b1;" << endl;
						pos pre = tetris[type_t][(angle_t+get<3>(op_case)+4)%4][(cnt_t-1+4)%4];
						cout << tab[st+9] << "next_valid = ( valid & ";
						cout << "( pos_i < `BOARD_HEIGHT ) & ( pos_j < `BOARD_WIDTH ) & ";	// natural overflow
						cout << "( ( (cnt == 4'd0) | (piece_type == `NULL_PIECE) ) ";
						for(int cnt_t2 = 0 ; cnt_t2 < 4 ; cnt_t2++) {
							cout << " | ";
							pos tem = tetris[type_t][angle_t][cnt_t2];
							cout << "( ";
							cout << "( cnt != 4'd0 ) &";
							cout << "( falling_piece_i " << get<1>(op_case) << " + " << pre.delta_i << " == falling_piece_i + " << tem.delta_i << " ) & ";
							cout << "( falling_piece_j " << get<2>(op_case) << " + " << pre.delta_j << " == falling_piece_j + " << tem.delta_j << " )";
							cout << " )";
						}
						cout << " ) );" << endl;
					}
					else {
						cout << tab[st+9] << "next_cnt = 4'd0;" << endl;
					}
					cout << tab[st+8] << "end" << endl;
				}
				cout << tab[st+7] << "endcase" << endl;
				cout << tab[st+6] << "end" << endl;
			}
			cout << tab[st+5] << "endcase" << endl;
			cout << tab[st+4] << "end" << endl;
		}
		cout << tab[st+3] << "endcase" << endl;
		cout << tab[st+2] << "end" << endl;
	}
	cout << tab[st+2] << "default: begin" << endl << tab[st+2] << "end" << endl;
	cout << tab[st+1] << "endcase" << endl;
	cout << tab[st+0] << "end" << endl;
	
	// ==============================================
	
	cout << tab[st+0] << "UPDATE_STATE: begin" << endl;
	cout << tab[st+1] << "case(op_type)" << endl;	// op_type
	for(auto op_case : {make_tuple("`LEFT_MOVE_OP","+ 0","- 1",0),make_tuple("`RIGHT_MOVE_OP","+ 0","+ 1",0),
							make_tuple("`DOWN_MOVE_OP","+ 1","+ 0",0),make_tuple("`SPIN_OP","+ 0","+ 0",1)}) {
		cout << tab[st+2] << get<0>(op_case) << ": begin" << endl;
		cout << tab[st+3] << "case(falling_piece_type)" << endl;	// type of falling piece
		for(int type_t = 0 ; type_t < 7 ; type_t++) {
			cout << tab[st+4] << "`" << name[type_t] << "_PIECE: begin" << endl;
			cout << tab[st+5] << "case(falling_piece_angle)" << endl;	// angle of falling_piece
			for(int angle_t = 0 ; angle_t < 4; angle_t++) {
				cout << tab[st+6] << "2'd" << angle_t << ": begin" << endl;
				cout << tab[st+7] << "case(cnt)" << endl;	// cnt (check by order)
				for(int cnt_t = 0 ; cnt_t < 9 ; cnt_t++) {
					cout << tab[st+8] << "4'd" << cnt_t << ": begin" << endl;
					
					if(cnt_t < 4) {
						pos now = tetris[type_t][angle_t][cnt_t];
						cout << tab[st+9] << "pos_i = falling_piece_i + " << now.delta_i << ";" << endl;		
						cout << tab[st+9] << "pos_j = falling_piece_j + " << now.delta_j << ";" << endl;		
						cout << tab[st+9] << "write_enable = 1'b1;" << endl;
						cout << tab[st+9] << "new_piece_type = `NULL_PIECE;" << endl;				
						cout << tab[st+9] << "next_cnt = cnt + 1'b1;" << endl;
					}
					else if(cnt_t < 8) {
						pos now = tetris[type_t][(angle_t+get<3>(op_case)+4)%4][cnt_t-4];
						cout << tab[st+9] << "pos_i = falling_piece_i " << get<1>(op_case) << " + " << now.delta_i << ";" << endl;		
						cout << tab[st+9] << "pos_j = falling_piece_j " << get<2>(op_case) << " + " << now.delta_j << ";" << endl;		
						cout << tab[st+9] << "write_enable = 1'b1;" << endl;
						cout << tab[st+9] << "new_piece_type = `" << name[type_t] << "_PIECE;" << endl;		
						cout << tab[st+9] << "next_cnt = cnt + 1'b1;" << endl;
					}
					else {
						cout << tab[st+9] << "next_state = WAIT_STATE;" << endl;
						cout << tab[st+9] << "write_enable = 1'b0;" << endl;
						cout << tab[st+9] << "next_cnt = 4'd0;" << endl;
					}
					cout << tab[st+8] << "end" << endl;
				}
				cout << tab[st+7] << "endcase" << endl;
				cout << tab[st+6] << "end" << endl;
			}
			cout << tab[st+5] << "endcase" << endl;
			cout << tab[st+4] << "end" << endl;
		}
		cout << tab[st+3] << "endcase" << endl;
		cout << tab[st+2] << "end" << endl;
	}
	cout << tab[st+2] << "default: begin" << endl << tab[st+2] << "end" << endl;
	cout << tab[st+1] << "endcase" << endl;
	cout << tab[st+0] << "end" << endl;
	return 0;
}

