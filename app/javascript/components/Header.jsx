import React, {Component} from 'react';
import { Navbar, NavbarBrand, Nav, NavbarToggler, Collapse, NavItem, Button, Modal, ModalHeader, ModalBody } from 'reactstrap';
import {NavLink} from 'react-router-dom';
import LoginModal from "./LoginModal";
import SignUpModal from "./SignupModal";


class Header extends Component{
    constructor(props){
        super(props);
        this.state = {
            isNavOpen: false,
            isModalSignUpOpen: false,
            isModalLoginOpen: false,
        };
        this.toggleNav = this.toggleNav.bind(this);
        this.toggleModalSignUp = this.toggleModalSignUp.bind(this);
        this.toggleModalLogin = this.toggleModalLogin.bind(this);
        this.handleLogout = this.handleLogout.bind(this);
    }

    toggleNav(){
        this.setState({
            isNavOpen: !this.state.isNavOpen
        });
    }

    toggleModalSignUp(){
        this.setState({
            isModalSignUpOpen: !this.state.isModalSignUpOpen,
        });
    }

    toggleModalLogin(){
        this.setState({
            isModalLoginOpen: !this.state.isModalLoginOpen,
        });
    }

    handleLogout(event){
        event.preventDefault();
        localStorage.removeItem('token')
        this.props.onUsernameChange(-1, '', false);
        this.props.history.push('/');
    }

    render(){
        return(
            <>
                <Navbar dark bg-primary expand="lg">
                    <div className="container">
                        <NavbarToggler onClick={this.toggleNav}/>
                        <Collapse isOpen={this.state.isNavOpen} navbar>
                            <NavbarBrand className="lionhelp">LionHelp</NavbarBrand>
                            <Nav className="me-auto" navbar>
                                <NavItem>
                                    <NavLink className="nav-link" to="/"><span className="fa fa-home fa-lg"/> Home</NavLink>
                                </NavItem>
                                { this.props.login && (
                                    <>
                                        <NavItem>
                                            <NavLink className="nav-link" to="/cur_posts">
                                                <span className="fa fa-cubes fa-lg"/> Current Requests
                                            </NavLink>
                                        </NavItem>
                                        <NavItem>
                                            <NavLink className="nav-link" to="/pre_posts">
                                                <span className="fa fa-check-circle fa-lg"/> Completed Requests
                                            </NavLink>
                                        </NavItem>
                                        <NavItem>
                                            <NavLink className="nav-link" to="/help_history">
                                                <span className="fa fa-history fa-lg"/> Help History
                                            </NavLink>
                                        </NavItem>
                                        <NavItem>
                                            <NavLink className="nav-link" to="/profile">
                                                <span className="fa fa-user-circle-o fa-lg"/> Profile
                                            </NavLink>
                                        </NavItem>
                                    </>
                                )}
                            </Nav>
                            <Nav className="ms-auto" navbar>

                                { this.props.login ? (
                                    <NavItem>
                                        <Button className="button-mr" outline onClick={this.handleLogout}>
                                            <span className="fa fa-sign-out fa-lg"/> Logout
                                        </Button>
                                    </NavItem>
                                ) : (
                                    <>
                                        <NavItem>
                                            <Button className="button-mr" outline onClick={this.toggleModalSignUp}>
                                                <span className="fa fa-user-plus fa-lg"/> Sign up
                                            </Button>
                                        </NavItem>
                                        <NavItem>
                                            <Button className="button-mr" outline onClick={this.toggleModalLogin}>
                                                <span className="fa fa-sign-in fa-lg"/> Login
                                            </Button>
                                        </NavItem>
                                    </>
                                )}
                            </Nav>
                        </Collapse>
                    </div>
                </Navbar>
                <Modal isOpen={this.state.isModalSignUpOpen} toggle={this.toggleModalSignUp}>
                    <ModalHeader toggle={this.toggleModalSignUp}>Sign Up</ModalHeader>
                    <SignUpModal onUsernameChange={this.props.onUsernameChange} toggleModalSignUp={this.toggleModalSignUp} />
                </Modal>
                <Modal isOpen={this.state.isModalLoginOpen} toggle={this.toggleModalLogin}>
                    <ModalHeader toggle={this.toggleModalLogin}>Login</ModalHeader>
                    <LoginModal onUsernameChange={this.props.onUsernameChange} toggleModalLogin={this.toggleModalLogin} />
                </Modal>
            </>
        );
    }
}

export default Header;