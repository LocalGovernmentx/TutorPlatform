import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  final List<bool> _selectedGender = [true, false];
  bool? _nicknameDuplicate;
  bool _validatingEmail = false;
  bool _emailValidated = false;
  String? _emailErrorMessage;

  String? _getNicknameHelperText(String text) {
    if (text.isEmpty) {
      return null;
    } else if (_nicknameDuplicate == true) {
      return null;
    } else {
      return '사용할 수 있는 닉네임입니다';
    }
  }

  String? _getNicknameErrorText(String text) {
    if (text.isEmpty && _nicknameDuplicate != null) {
      return '닉네임을 입력해주세요';
    } else if (_nicknameDuplicate == true) {
      return '이미 사용중인 닉네임입니다';
    }
    return null;
  }

  bool _possibleNickname(String nickname) {
    // 서버통신
    if (['a', 'b', 'c', 'd'].contains(nickname)) {
      return false;
    }
    return true;
  }

  void _validateEmail(String validation) {
    // 서버통신
    if (validation == '1234') {
      _validatingEmail = false;
      _emailValidated = true;
      _controllers[3].text = '';
    }
  }

  bool _emailCheck(String email) {
    // 서버통신
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (emailRegex.hasMatch(email)) {
      _emailErrorMessage = null;
      return true;
    }
    _emailErrorMessage = '이메일 형식이 아닙니다';
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 적어야 합니다';
                    }
                    return null;
                  },
                  controller: _controllers[0],
                  decoration: const InputDecoration(
                    labelText: '이름',
                  ),
                ),
                const Text('한번 정한 닉네임은 바꿀 수 없습니다'),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '닉네임을 적어야 합니다';
                          }
                          return null;
                        },
                        controller: _controllers[1],
                        decoration: InputDecoration(
                          labelText: '닉네임',
                          helperText:
                              _getNicknameHelperText(_controllers[1].text),
                          errorText:
                              _getNicknameErrorText(_controllers[1].text),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _nicknameDuplicate =
                                !_possibleNickname(_controllers[1].text);
                          });
                        },
                        child: const Text('중복 확인'),
                      ),
                    )
                  ],
                ),
                ToggleButtons(
                  isSelected: _selectedGender,
                  onPressed: (int index) {
                    setState(() {
                      if (!_selectedGender[index]) {
                        _selectedGender[index] = true;
                        _selectedGender[1 - index] = false;
                      }
                    });
                  },
                  children: const [Text('남성'), Text('여성')],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 적어야 합니다';
                          }
                          if (!_emailValidated) {
                            return '이메일을 인증받아야 합니다';
                          }
                          return null;
                        },
                        controller: _controllers[2],
                        decoration: InputDecoration(
                          labelText: '이메일',
                          helperText: _emailValidated ? '이메일이 인증되었습니다' : null,
                          errorText: _emailErrorMessage,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (_emailValidated) {
                              _emailValidated = false;
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_emailCheck(_controllers[2].text)) {
                              _validatingEmail = true;
                            }
                            _emailValidated = false;
                          });
                        },
                        child: const Text('인증'),
                      ),
                    )
                  ],
                ),
                if (_validatingEmail)
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _controllers[3],
                          decoration: const InputDecoration(
                            labelText: '인증번호',
                            helperText: 'helper',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _validateEmail(_controllers[3].text);
                          });
                        },
                        child: Text('인증하기'),
                      ))
                    ],
                  ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 적어야 합니다';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _controllers[4],
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (_controllers[4].text != _controllers[5].text) {
                      return '비밀번호가 다릅니다';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _controllers[5],
                  decoration: const InputDecoration(
                    labelText: '비밀번호 확인',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState?.validate() ?? true) {
                      print('ok');
                    }
                  },
                  child: const Text('Sign Up'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
