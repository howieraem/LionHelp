import React from "react";
import {Button, ModalBody, Input, Form, FormGroup, FormFeedback, Label, Alert} from "reactstrap";
import { useHistory } from 'react-router-dom';


export default function SignUpModal({onUsernameChange, toggleModalSignUp}) {
    let history = useHistory();

    const [state, setState] = React.useState({
        "email": null,
        "password": null,
        "password2": null,
        "firstName": null,
        "lastName": null
    })

    const [pwdMsg, setPwdMsg] = React.useState(null);
    const [alert, setAlert] = React.useState(null);

    const handleInputChange = (ev) => {
        const target = ev.target;
        const value = target.value;
        const name = target.name;
        setState({
            ...state,
            [name]: value
        });
    }

    const handlePwd2Change = (ev) => {
        const value = ev.target.value;
        setState({
            ...state,
            password2: value
        })
        if (state.password && state.password !== value) {
            setPwdMsg("Password mismatched!");
        } else {
            setPwdMsg(null);
        }
    }

    const handleSubmit = async (ev) => {
        ev.preventDefault();
        const url = "/api/v1/signup";
        if (state.password === state.password2) {
            const {password2, ...body} = state;
            const token = document.querySelector('meta[name="csrf-token"]').content;
            try {
                const response = await fetch(url, {
                    method: "POST",
                    headers: {
                        "X-CSRF-Token": token,
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(body)
                });
                const json = await response.json();
                if (!response.ok) {
                    throw { status: response.status, message: json.error };
                }
                localStorage.setItem("token", json.token);
                setAlert(null);
                onUsernameChange(json.user.id, json.user.email, true);
                toggleModalSignUp();
                history.push('/');
            } catch (error) {
                setAlert(`Sign up failed (status ${error.status}): ${error.message}`);
            }
        }
    };

    return (
        <ModalBody>
            <div className="row">
                <Form onSubmit={handleSubmit} className="col-12 col-sm-10 offset-sm-1">
                    <FormGroup floating>
                        <Input
                            id="signUpEmail"
                            name="email"
                            type="email"
                            value={state.email}
                            onChange={handleInputChange}
                        />
                        <Label for="signUpEmail">Email</Label>
                    </FormGroup>
                    {' '}
                    <FormGroup floating>
                        <Input
                            id="signUpPassword"
                            name="password"
                            type="password"
                            value={state.password}
                            onChange={handleInputChange}
                        />
                        <Label for="signUpPassword">Password</Label>
                    </FormGroup>
                    {' '}
                    <FormGroup floating>
                        <Input
                            id="signUpPassword2"
                            name="password2"
                            type="password"
                            value={state.password2}
                            onChange={handlePwd2Change}
                            invalid={Boolean(pwdMsg)}
                        />
                        <Label for="signUpPassword2">Confirm Password</Label>
                        { pwdMsg && (
                                <FormFeedback>
                                    {pwdMsg}
                                </FormFeedback>
                            )
                        }
                    </FormGroup>
                    {' '}
                    <FormGroup floating>
                        <Input
                            id="signUpFirstName"
                            name="firstName"
                            value={state.firstName}
                            onChange={handleInputChange}
                        />
                        <Label for="signUpFirstName">Your First/Given Name</Label>
                    </FormGroup>
                    {' '}
                    <FormGroup floating>
                        <Input
                            id="signUpLastName"
                            name="lastName"
                            value={state.lastName}
                            onChange={handleInputChange}
                        />
                        <Label for="signUpLastName">Your Last/Family Name</Label>
                    </FormGroup>
                    {' '}
                    {alert && <Alert color="danger">{alert}</Alert>}
                    <Button type="submit" value="submit" color="primary" style={{width:"100%"}}>Sign Up</Button>
                </Form>
            </div>
        </ModalBody>
    );
}
