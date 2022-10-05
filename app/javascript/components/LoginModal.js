import React from "react";
import {Alert, Button, ModalBody, Input, Form, FormGroup, Label} from "reactstrap";
import { useHistory } from 'react-router-dom';


export default function LoginModal({onUsernameChange, toggleModalLogin}) {
    let history = useHistory();

    const [state, setState] = React.useState({
        "email": null,
        "password": null
    })

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

    const handleSubmit = async (ev) => {
        ev.preventDefault();
        const url = "/api/v1/login";
        const body = {
            ...state
        };
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
            toggleModalLogin();
            history.push('/');
        } catch (error) {
            setAlert(`Login failed (status ${error.status}): ${error.message}`);
        }
    };

    return (
        <ModalBody>
            <div className="row">
                <Form onSubmit={handleSubmit} className="col-12 col-sm-10 offset-sm-1">
                    <FormGroup floating>
                        <Input
                            id="loginEmail"
                            name="email"
                            type="email"
                            value={state.email}
                            onChange={handleInputChange}
                        />
                        <Label for="loginEmail">Email</Label>
                    </FormGroup>
                    {' '}
                    <FormGroup floating>
                        <Input
                            id="loginPassword"
                            name="password"
                            type="password"
                            value={state.password}
                            onChange={handleInputChange}
                        />
                        <Label for="loginPassword">Password</Label>
                    </FormGroup>
                    {' '}
                    {alert && <Alert color="danger">{alert}</Alert>}
                    <Button type="submit" value="submit" color="primary" style={{width:"100%"}}>Login</Button>
                </Form>
            </div>
        </ModalBody>
    );
}
