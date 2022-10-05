import React from 'react';
import {Button, Form, FormGroup, Label, Input, Col, Row, FormFeedback, Alert} from 'reactstrap';
import Loading from "./Loading";


export default function Profile({usrId, email, login}) {
    if (!login)  {
        return (
            <div className="container">
                <div className="row">
                    <div className="col-12">
                        <h5 style={{marginTop:"100px", fontFamily:"Arial Black"}}>Please login first!</h5>
                    </div>
                </div>
            </div>
        );
    }

    const uri = `/api/v1/users/${usrId}`;
    const [state, setState] = React.useState({
        firstName: null,
        lastName: null,
        credit: 0,
        loading: true,
    });
    const [alert, setAlert] = React.useState(null);
    const [disableBtn, setDisableBtn] = React.useState(false);

    React.useEffect(() => {
        fetch(uri)
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error("Error loading profile!");
            })
            .then(json => {
                setState({
                    firstName: json.firstName,
                    lastName: json.lastName,
                    credit: json.credit,
                    loading: false,
                });
            })
            .catch(err => { console.log(err) });
    }, [usrId])

    const handleInputChange = (event) => {
        const target = event.target;
        const value = target.value;
        const name = target.name;
        setState({
            ...state,
            [name]: value
        });
    }

    const handleSubmit = async (ev) => {
        ev.preventDefault();
        setDisableBtn(true);
        const { loading, ...body } = state;
        const token = document.querySelector('meta[name="csrf-token"]').content;
        try {
            const response = await fetch(uri, {
                method: "PUT",
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
            setAlert(null);
        } catch (error) {
            setAlert(`Profile update failed (status ${error.status}): ${error.message}`);
        }
        setDisableBtn(false);
    }

    const validate = (firstName, lastName) => {
        const errors = {
            firstName: null,
            lastName: null,
        };
        if (state.loading)  return errors;
        if (!firstName)  errors.firstName = 'Your first name should not be empty!';
        if (!lastName)  errors.lastName = 'Your last name should not be empty!';
        return errors;
    }

    const errors = validate(state.firstName, state.lastName);

    if (state.loading) {
        return <Loading />
    }
    return (
        <div className="container">
            <div className="row">
                <div className="col-12">
                    <h5 style={{marginTop:"100px", fontFamily:"Arial Black"}}>Update Your Profile</h5>
                    <h6 style={{marginTop:"20px", fontFamily:"Arial Black"}}>{email}</h6>
                    <h6 style={{marginTop:"20px", fontFamily:"Arial Black"}}>Credit: {state.credit}</h6>
                    <hr className="separation" />
                </div>
            </div>
            <div className="row row-content">
                <Form onSubmit={handleSubmit} className="form-style">
                    <Row>
                        <Col sm={12} md={{size:6, offset:3}}>
                            <FormGroup className="form-style-form-group">
                                <Label htmlFor="firstName" className="form-style-label">First Name *</Label>
                                <Input
                                    type="text"
                                    id="firstName"
                                    name="firstName"
                                    className="form-style-input"
                                    required={true}
                                    value={state.firstName}
                                    invalid={Boolean(errors.firstName)}
                                    onChange={handleInputChange}
                                />
                                <FormFeedback>{errors.firstName}</FormFeedback>
                            </FormGroup>
                        </Col>
                    </Row>
                    <Row>
                        <Col xs={12} md={{size:6, offset:3}}>
                            <FormGroup className="form-style-form-group">
                                <Label htmlFor="lastName" className="form-style-label">Last Name *</Label>
                                <Input
                                    type="text"
                                    id="lastName"
                                    name="lastName"
                                    className="form-style-input"
                                    required={true}
                                    value={state.lastName}
                                    invalid={Boolean(errors.lastName)}
                                    onChange={handleInputChange}
                                />
                                <FormFeedback>{errors.lastName}</FormFeedback>
                            </FormGroup>
                        </Col>
                    </Row>
                    {alert && (
                        <Row>
                            <Col sm={12} md={{size:6, offset:3}}>
                                <Alert color="danger">{alert}</Alert>
                            </Col>
                        </Row>
                    )}
                    <Row>
                        <Col sm={12} md={{size:6, offset:3}}>
                            <Button
                                type="submit"
                                value="submit"
                                disabled={Object.values(errors).some(v => Boolean(v)) || disableBtn}
                                style={{
                                    backgroundColor:"rgba(0, 51, 160, 1)",
                                    width:"100%",
                                    fontFamily:"Arial Black"
                                }}
                            >
                                Save
                            </Button>
                        </Col>
                    </Row>
                </Form>
            </div>
        </div>
    );
}
